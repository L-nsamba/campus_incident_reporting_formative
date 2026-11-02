class Validators {
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (value.trim().length < 2) {
      return 'Please enter a valid name';
    }

    return null;
  }

  // Registration email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your ALU email address';
    }

    final email = value.trim().toLowerCase();

    if (!RegExp(r'^[^@\s]+@alustudent\.com$').hasMatch(email)) {
      return 'Please use your @alustudent.com email';
    }

    return null;
  }

  // Login email validation
  static String? validateLoginEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  // Validate password match
  static String? validateConfirmPassword(
    String? value,
    String passwordToMatch,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != passwordToMatch) {
      return 'Passwords do not match';
    }

    return null;
  }

  // Validate login password
  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
}
