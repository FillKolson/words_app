/// Validation utilities for user input

/// Validates password strength
/// Returns empty string if valid, error message if invalid
String validatePassword(String password) {
  if (password.isEmpty) {
    return 'Password cannot be empty';
  }
  if (password.length < 6) {
    return 'Password must be at least 6 characters';
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one digit';
  }
  return '';
}

/// Validates email format
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Validates English word (no empty, no special chars)
bool isValidWord(String word) {
  if (word.isEmpty || word.length > 100) {
    return false;
  }
  return !word.contains(RegExp(r'[0-9!@#$%^&*()_+=[\]{};:",.<>?/\\|`~-]'));
}

/// Validates difficulty level (1-5)
bool isValidDifficulty(int difficulty) {
  return difficulty >= 1 && difficulty <= 5;
}
