import 'dart:io';

import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/campus_location_enum.dart';
import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:campus_reporting_app/enum/incident_status_enum.dart';
import 'package:campus_reporting_app/models/incident.dart';
import 'package:campus_reporting_app/providers/incident_provider.dart';
import 'package:campus_reporting_app/services/cloudinary_service.dart';
import 'package:campus_reporting_app/utils/validators.dart';
import 'package:campus_reporting_app/widgets/custom_text_field.dart';
import 'package:campus_reporting_app/widgets/primary_button.dart';
import 'package:campus_reporting_app/widgets/student/image_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitIncidentScreen extends StatefulWidget {
  const SubmitIncidentScreen({super.key});

  @override
  State<SubmitIncidentScreen> createState() => _SubmitIncidentScreenState();
}

class _SubmitIncidentScreenState extends State<SubmitIncidentScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  bool _isSubmitting = false;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _specificLocationController = TextEditingController();

  IncidentCategoryEnum? _selectedCategory;
  CampusLocationEnum? _selectedLocation;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _specificLocationController.dispose();
    super.dispose();
  }

  // If the students specifies classroom or other as campus location, they will be prompted to provide more details
  bool get _requiresSpecificLocation =>
      _selectedLocation == CampusLocationEnum.classroom ||
      _selectedLocation == CampusLocationEnum.other;

  String? _validateSpecificLocation(String? value) {
    if (_requiresSpecificLocation && (value == null || value.trim().isEmpty)) {
      return 'Please specify the exact location';
    }

    return null;
  }

  String _categoryLabel(IncidentCategoryEnum category) {
    switch (category) {
      case IncidentCategoryEnum.facilities:
        return 'Facilities';
      case IncidentCategoryEnum.water:
        return 'Water';
      case IncidentCategoryEnum.electricity:
        return 'Electricity';
      case IncidentCategoryEnum.furniture:
        return 'Furniture';
      case IncidentCategoryEnum.sanitation:
        return 'Sanitation';
      case IncidentCategoryEnum.safety:
        return 'Safety';
      case IncidentCategoryEnum.other:
        return 'Other';
    }
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: const BorderSide(color: AppColors.border),
      ),
    );
  }

  Future<void> _submitIncident() async {
    final incidentProvider = context.read<IncidentProvider>();
    final cloudinary = context.read<CloudinaryService>();
    if (!_formKey.currentState!.validate()) return;

    if (_selectedCategory == null || _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category and location.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Get the currently logged-in user's ID.
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('You must be logged in to submit an incident.');
      }

      // Upload the image only if the student selected one.
      String? photoUrl;

      if (_selectedImage != null) {
        photoUrl = await cloudinary.uploadImage(_selectedImage!);
      }

      // Build the location value.
      final locationLabel = _selectedLocation!.label;
      final specificLocation = _specificLocationController.text.trim();

      final location = specificLocation.isNotEmpty
          ? '$locationLabel, $specificLocation'
          : locationLabel;

      // Create the incident.
      final incident = Incident(
        id: '',
        reporterId: user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory!,
        location: location,
        photoUrl: photoUrl,
        status: IncidentStatusEnum.submitted,
        createdAt: DateTime.now(),
        updatedAt: null,
      );

      await incidentProvider.createIncident(incident);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Incident submitted successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not submit incident: $e')));
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Report Details',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),

                const Text(
                  'Tell us about the issue',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 28),

                CustomTextField(
                  label: '',
                  hintText: 'Title',
                  controller: _titleController,
                  validator: Validators.validateIncident,
                ),
                const SizedBox(height: 14),

                DropdownButtonFormField<IncidentCategoryEnum>(
                  initialValue: _selectedCategory,
                  decoration: _dropdownDecoration('Category'),
                  items: IncidentCategoryEnum.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_categoryLabel(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),

                const SizedBox(height: 18),

                DropdownButtonFormField<CampusLocationEnum>(
                  initialValue: _selectedLocation,
                  decoration: _dropdownDecoration('Location'),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: CampusLocationEnum.values.map((location) {
                    return DropdownMenuItem(
                      value: location,
                      child: Text(location.label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedLocation = value;
                      _specificLocationController.clear();
                    });
                  },
                ),

                if (_requiresSpecificLocation) ...[
                  const SizedBox(height: 14),

                  CustomTextField(
                    label: 'Specify exact location',
                    hintText: 'e.g Congo, Lesotho',
                    controller: _specificLocationController,
                    validator: _validateSpecificLocation,
                  ),
                ],

                const SizedBox(height: 18),

                const Text(
                  'Description (Optional)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 9),

                CustomTextField(
                  label: '',
                  hintText: 'Tell us everything...',
                  controller: _descriptionController,
                  maxLines: 4,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Image attachment (Optional)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 10),

                ImagePickerWidget(
                  onImageSelected: (image) {
                    setState(() {
                      _selectedImage = image;
                    });
                  },
                ),

                const SizedBox(height: 20),

                PrimaryButton(
                  label: 'Continue',
                  onPressed: _submitIncident,
                  isLoading: _isSubmitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
