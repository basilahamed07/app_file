import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/google_signin_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/medical_logo_widget.dart';
import './widgets/register_link_widget.dart';
import './widgets/trust_footer_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _showBiometricPrompt = false;
  final FocusNode _focusNode = FocusNode();

  // Mock credentials for different user types
  final Map<String, Map<String, String>> _mockCredentials = {
    'Patient': {
      'email': 'patient@queuefree.com',
      'password': 'patient123',
    },
    'Doctor': {
      'email': 'doctor@queuefree.com',
      'password': 'doctor123',
    },
    'Admin': {
      'email': 'admin@queuefree.com',
      'password': 'admin123',
    },
  };

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleLogin(String email, String password, String role) async {
    setState(() {
      _isLoading = true;
    });

    // Unfocus any active text fields
    FocusScope.of(context).unfocus();

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    final mockCreds = _mockCredentials[role];
    if (mockCreds != null &&
        email == mockCreds['email'] &&
        password == mockCreds['password']) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Show biometric prompt for future logins
      setState(() {
        _isLoading = false;
        _showBiometricPrompt = true;
      });
    } else {
      setState(() {
        _isLoading = false;
      });

      // Show error message with mock credentials hint
      _showErrorDialog(
        'Invalid Credentials',
        'Please check your email and password.\n\nDemo Credentials:\n'
            'Patient: patient@queuefree.com / patient123\n'
            'Doctor: doctor@queuefree.com / doctor123\n'
            'Admin: admin@queuefree.com / admin123',
      );
    }
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate Google Sign-In delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Simulate successful Google Sign-In
    HapticFeedback.lightImpact();
    _navigateToPatientDashboard();
  }

  void _handleBiometricSuccess() {
    setState(() {
      _showBiometricPrompt = false;
    });

    HapticFeedback.lightImpact();
    _navigateToPatientDashboard();
  }

  void _handleBiometricCancel() {
    setState(() {
      _showBiometricPrompt = false;
    });

    _navigateToPatientDashboard();
  }

  void _navigateToPatientDashboard() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/patient-dashboard',
      (route) => false,
    );
  }

  void _handleRegisterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registration functionality will be implemented'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.error,
            ),
          ),
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: 94.h,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 6.h),

                      // Medical Logo
                      const MedicalLogoWidget(),

                      SizedBox(height: 4.h),

                      // Login Form
                      LoginFormWidget(
                        onLogin: _handleLogin,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 2.h),

                      // Google Sign-In
                      GoogleSignInWidget(
                        onGoogleSignIn: _handleGoogleSignIn,
                        isLoading: _isLoading,
                      ),

                      SizedBox(height: 2.h),

                      // Trust Footer
                      const TrustFooterWidget(),

                      SizedBox(height: 2.h),

                      // Register Link
                      RegisterLinkWidget(
                        onRegisterTap: _handleRegisterTap,
                      ),

                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),

            // Biometric Prompt Overlay
            if (_showBiometricPrompt)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: BiometricPromptWidget(
                      onBiometricSuccess: _handleBiometricSuccess,
                      onBiometricCancel: _handleBiometricCancel,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
