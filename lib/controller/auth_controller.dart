import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import '../app_routes.dart';

class AuthController {
  final AuthService _authService = AuthService();
  final BuildContext context;

  AuthController(this.context);

  /// Handles the login process.
  Future<void> handleLogin(String email, String password) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      _showErrorSnackbar('Please fill in all fields.');
      return;
    }

    _showLoadingDialog();

    try {
      final user = await _authService.login(email, password);
      _hideLoadingDialog();

      if (user != null) {
        // Navigate to the home screen on successful login
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorSnackbar(e.toString());
    }
  }

  /// Handles the registration process.
  Future<void> handleRegister(String email, String password, String confirmPassword) async {
    // Basic validation
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorSnackbar('Please fill in all fields.');
      return;
    }

    if (password != confirmPassword) {
      _showErrorSnackbar('Passwords do not match.');
      return;
    }

    _showLoadingDialog();

    try {
      final user = await _authService.register(email, password);
      _hideLoadingDialog();

      if (user != null) {
        // Navigate to the home screen on successful registration
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } catch (e) {
      _hideLoadingDialog();
      _showErrorSnackbar(e.toString());
    }
  }

  /// Shows a loading dialog.
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Hides the loading dialog.
  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  /// Shows an error message in a SnackBar.
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
