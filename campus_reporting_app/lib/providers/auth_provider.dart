import 'dart:async';

import 'package:campus_reporting_app/enum/user_role_enum.dart';
import 'package:campus_reporting_app/models/app_user.dart';
import 'package:campus_reporting_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  // Setting up the central auth state manager that listens and reacts to user sign in's and out's
  AuthProvider(this._authService) {
    _authSubscription = _authService.authStateChanges.listen(
      _onAuthStateChanged,
    );
  }

  User? _firebaseUser;
  AppUser? _appUser;

  bool _isLoading = false;
  bool _isInitializing = true;

  String? _errorMessage;

  StreamSubscription<User?>? _authSubscription;

  User? get firebaseUser => _firebaseUser;
  AppUser? get appUser => _appUser;

  bool get isLoading => _isLoading || _isInitializing;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated =>
      _firebaseUser != null && _firebaseUser!.emailVerified && _appUser != null;

  bool get isEmailVerified => _firebaseUser?.emailVerified ?? false;

  bool get isStudent => _appUser?.role == UserRoleEnum.student;

  bool get isStaff => _appUser?.role == UserRoleEnum.staff;

  // Handling Firebase authentication changes
  Future<void> _onAuthStateChanged(User? user) async {
    _firebaseUser = user;
    _appUser = null;
    _errorMessage = null;

    if (user == null) {
      _isInitializing = false;
      notifyListeners();
      return;
    }

    try {
      await user.reload();

      final refreshedUser = _authService.currentFirebaseUser;
      _firebaseUser = refreshedUser;

      if (refreshedUser != null && refreshedUser.emailVerified) {
        _appUser = await _authService.getUserProfile(refreshedUser.uid);
      }
    } catch (e) {
      _errorMessage = 'Unable to load your account profile.';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  // Registering a student
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      await _authService.registerStudent(
        name: name,
        email: email,
        password: password,
      );

      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);

    try {
      await _authService.login(email: email, password: password);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Resending verification email
  Future<bool> resendVerificationEmail() async {
    try {
      await _authService.resendVerificationEmail();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Refreshing verification status after user returns to the app

  Future<void> refreshUser() async {
    final user = _authService.currentFirebaseUser;

    if (user == null) {
      _firebaseUser = null;
      _appUser = null;
      notifyListeners();
      return;
    }

    try {
      await user.reload();

      _firebaseUser = _authService.currentFirebaseUser;
      _appUser = null;

      if (_firebaseUser?.emailVerified == true) {
        _appUser = await _authService.getUserProfile(_firebaseUser!.uid);
      }

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Unable to refresh your account information.';
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  // Password Reset
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Logging out
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
