import 'dart:async';

import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/repositories/incident_repository.dart';
import 'package:flutter/material.dart';

// Connecting the incident repository to the screens
class IncidentProvider extends ChangeNotifier {
  final IncidentRepository _incidentRepository;
  String? _incidentsError;
  String? _myIncidentsError;

  String? get incidentsError => _incidentsError;
  String? get myIncidentsError => _myIncidentsError;

  IncidentProvider(this._incidentRepository);

  // Incident collections
  List<Incident> _incidents = [];
  List<Incident> _myIncidents = [];

  // Stream subscriptions which handle a series of asynchronus events
  StreamSubscription<List<Incident>>? _allIncidentsSubscription;
  StreamSubscription<List<Incident>>? _myIncidentsSubscription;

  // Loading states
  bool _isLoadingIncidents = false;
  bool _isLoadingMyIncidents = false;
  bool _isSubmitting = false;

  // Error state
  String? _errorMessage;

  // Getters
  List<Incident> get incidents => _incidents;
  List<Incident> get myIncidents => _myIncidents;

  bool get isLoadingIncidents => _isLoadingIncidents;
  bool get isLoadingMyIncidents => _isLoadingMyIncidents;
  bool get isSubmitting => _isSubmitting;

  String? get errorMessage => _errorMessage;

  String? _listeningUserId;

  // Listen to all campus incidents
  void listenToAllIncidents() {
    if (_allIncidentsSubscription != null) return;

    _isLoadingIncidents = true;
    _errorMessage = null;
    _incidentsError = null;

    notifyListeners();

    _allIncidentsSubscription = _incidentRepository.getAllIncidents().listen(
      (incidents) {
        _incidents = incidents;
        _isLoadingIncidents = false;
        notifyListeners();
      },
      onError: (error, stack) {
        debugPrint('All incidents stream error: $error\n$stack');
        _allIncidentsSubscription = null;
        _incidentsError = 'Unable to load campus incidents.';
        _isLoadingIncidents = false;
        notifyListeners();
      },
    );
  }

  // Listen to incidents belonging to a particular student
  void listenToMyIncidents(String userId) {
    // Ensuring that if a user logs out and another logs in, it must subscribe to the new users reports
    if (_listeningUserId == userId && _myIncidentsSubscription != null) {
      return;
    }

    _myIncidentsSubscription?.cancel();
    _myIncidentsSubscription = null;
    _listeningUserId = userId;
    _myIncidentsError = null;

    if (userId.isEmpty) {
      _errorMessage = 'Unable to identify the current user';
      notifyListeners();
      return;
    }

    _isLoadingMyIncidents = true;
    _errorMessage = null;
    notifyListeners();

    _myIncidentsSubscription = _incidentRepository
        .getUserIncidents(userId)
        .listen(
          (incidents) {
            _myIncidents = incidents;
            _isLoadingMyIncidents = false;
            notifyListeners();
          },
          onError: (error, stack) {
            debugPrint('My incidents stream error: $error\n$stack');
            _myIncidentsSubscription = null;
            _myIncidentsError = 'Unable to load your reports';
            _isLoadingMyIncidents = false; 
            notifyListeners();
          },
        );
  }

  // Submitting a new incident
  Future<String> createIncident(Incident incident) async {
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final incidentId = await _incidentRepository.createIncident(incident);

      return incidentId;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception', '');
      rethrow;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Retrieving an individual incident
  Future<Incident?> getIncidentById(String incidentId) async {
    try {
      return await _incidentRepository.getIncidentById(incidentId);
    } catch (e) {
      _errorMessage = 'Unable to retrieve incident details';
      notifyListeners();
      rethrow;
    }
  }

  // Clear any displayed error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> retryAllIncidents() async {
    await _allIncidentsSubscription?.cancel();
    _allIncidentsSubscription = null;

    _incidents = [];
    _errorMessage = null;

    listenToAllIncidents();
  }
}
