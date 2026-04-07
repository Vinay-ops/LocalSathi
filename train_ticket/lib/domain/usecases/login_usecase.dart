/// Business logic for login validation and processing
/// Separated from UI to be reusable and testable
class LoginUsecase {
  /// Validates phone number format
  /// Returns null if valid, error message if invalid
  String? validatePhoneNumber(String phone) {
    final trimmedPhone = phone.trim();

    if (trimmedPhone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (trimmedPhone.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(trimmedPhone)) {
      return 'Phone number must start with 6, 7, 8, or 9';
    }

    return null; // Valid
  }

  /// Simulates login process (replace with actual API call)
  Future<bool> performLogin(String phoneNumber) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In real app, this would be an API call to backend
      // For now, we just return success for valid numbers
      return validatePhoneNumber(phoneNumber) == null;
    } catch (e) {
      return false;
    }
  }
}
