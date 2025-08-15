import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    try {
      await _authService.initialize();

      if (_authService.isAuthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }

      _authService.authStateStream.listen((authState) {
        if (authState.event == AuthChangeEvent.signedIn) {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      });
    } catch (e) {
      debugPrint('Auth initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback color
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Compact branding with enhanced visibility
                    Text(
                      'HomeSnap Pro',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Shoot Like a Pro. Sell Like a Boss.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.yellow,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32),

                    // Ultra-compact login form
                    LoginFormWidget(
                      onLogin: _handleLogin,
                      onSignUp: _handleSignUp,
                      onForgotPassword: _handleForgotPassword,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 20),

                    // Minimal social login
                    SocialLoginWidget(
                      onGoogleLogin: _handleGoogleLogin,
                      onAppleLogin: _handleAppleLogin,
                    ),

                    SizedBox(height: 16),

                    // Compact biometric
                    BiometricPromptWidget(
                      biometricType: 'face',
                      onEnableBiometric: _handleBiometricLogin,
                      onSkipBiometric: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(String email, String password) async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithPassword(email: email, password: password);
    } catch (e) {
      _showErrorMessage('Login failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSignUp(
      String email, String password, String fullName) async {
    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        role: 'agent',
      );

      _showSuccessMessage(
          'Account created successfully! Please check your email for verification.');
    } catch (e) {
      _showErrorMessage('Sign up failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleForgotPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      _showSuccessMessage(
          'Password reset email sent. Please check your inbox.');
    } catch (e) {
      _showErrorMessage('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showErrorMessage('Google login failed: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleAppleLogin() async {
    setState(() => _isLoading = true);

    try {
      await _authService.signInWithApple();
    } catch (e) {
      _showErrorMessage('Apple login failed: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleBiometricLogin() async {
    _showInfoMessage('Biometric authentication coming soon!');
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message, style: TextStyle(color: Colors.white)),
          backgroundColor: AppTheme.black,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message, style: TextStyle(color: Colors.black)),
          backgroundColor: AppTheme.yellow,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
    }
  }

  void _showInfoMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message, style: TextStyle(color: Colors.black)),
          backgroundColor: AppTheme.yellow,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))));
    }
  }
}
