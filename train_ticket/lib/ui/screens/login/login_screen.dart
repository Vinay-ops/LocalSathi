import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen_ui.dart';
import '../home/home_screen.dart';
import '../../../domain/usecases/login_usecase.dart';

/// Login Screen - Main Container
/// Manages state and delegates UI rendering to LoginScreenUI
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final LoginUsecase _loginUsecase = LoginUsecase();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  /// Handle login action - orchestrates validation and navigation
  void _handleLogin() async {
    final phone = _phoneController.text.trim();

    // Validate phone number
    final validationError = _loginUsecase.validatePhoneNumber(phone);
    if (validationError != null) {
      setState(() => _errorMessage = validationError);
      return;
    }

    // Clear error message
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Perform login
    final isSuccess = await _loginUsecase.performLogin(phone);

    if (mounted) {
      setState(() => _isLoading = false);

      if (isSuccess) {
        // Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userPhone', phone);

        if (!mounted) return;
        // Navigate to home screen on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() => _errorMessage = 'Login failed. Please try again.');
      }
    }
  }

  /// Handle phone field changes
  void _handlePhoneChanged(String value) {
    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoginScreenUI(
      phoneController: _phoneController,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onLoginPressed: _handleLogin,
      onPhoneChanged: _handlePhoneChanged,
    );
  }
}
