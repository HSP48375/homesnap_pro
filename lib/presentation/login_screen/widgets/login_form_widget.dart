import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_theme.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final Function(String email, String password, String fullName) onSignUp;
  final Function(String email) onForgotPassword;
  final bool isLoading;

  const LoginFormWidget({
    Key? key,
    required this.onLogin,
    required this.onSignUp,
    required this.onForgotPassword,
    required this.isLoading,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Focus nodes for border color management
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _fullNameFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Ultra-compact tab bar
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(16),
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Sign In'),
                Tab(text: 'Sign Up'),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Ultra-compact tab views
          SizedBox(
            height: _tabController.index == 0 ? 140 : 180,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSignInForm(),
                _buildSignUpForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Column(
      children: [
        // Email Field - Ultra minimal
        _buildMinimalInputField(
          controller: _emailController,
          focusNode: _emailFocus,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),

        SizedBox(height: 16),

        // Password Field - Ultra minimal
        _buildMinimalInputField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          hint: 'Password',
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withAlpha(128),
              size: 16,
            ),
          ),
          validator: _validatePassword,
        ),

        SizedBox(height: 8),

        // Forgot Password - Ultra compact
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: _handleForgotPassword,
            child: Text(
              'Forgot Password?',
              style: GoogleFonts.inter(
                color: AppTheme.yellow,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 16),

        // Sign In Button - 45px height
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSignIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.yellow,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Sign In',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      children: [
        // Full Name Field - Ultra minimal
        _buildMinimalInputField(
          controller: _fullNameController,
          focusNode: _fullNameFocus,
          hint: 'Full Name',
          validator: _validateFullName,
        ),

        SizedBox(height: 12),

        // Email Field - Ultra minimal
        _buildMinimalInputField(
          controller: _emailController,
          focusNode: _emailFocus,
          hint: 'Email',
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        ),

        SizedBox(height: 12),

        // Password Field
        _buildMinimalInputField(
          controller: _passwordController,
          focusNode: _passwordFocus,
          hint: 'Password',
          obscureText: _obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => _obscurePassword = !_obscurePassword),
            child: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withAlpha(128),
              size: 16,
            ),
          ),
          validator: _validatePassword,
        ),

        SizedBox(height: 12),

        // Confirm Password Field
        _buildMinimalInputField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          hint: 'Confirm Password',
          obscureText: _obscureConfirmPassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
            child: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withAlpha(128),
              size: 16,
            ),
          ),
          validator: _validateConfirmPassword,
        ),

        SizedBox(height: 16),

        // Sign Up Button - 45px height
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.yellow,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: widget.isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Create Account',
                    style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalInputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24,
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(
                  color: Colors.white.withAlpha(128),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                suffixIcon: suffixIcon,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
              ),
            ),
          ),
          SizedBox(height: 4),
          Container(
            height: 1,
            width: double.infinity,
            color: focusNode.hasFocus
                ? AppTheme.yellow
                : Colors.white.withAlpha(77),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignUp(
        _emailController.text,
        _passwordController.text,
        _fullNameController.text,
      );
    }
  }

  void _handleForgotPassword() {
    if (_emailController.text.isNotEmpty) {
      widget.onForgotPassword(_emailController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter your email first'),
          backgroundColor: AppTheme.yellow,
        ),
      );
    }
  }
}
