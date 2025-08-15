import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  final SupabaseService _supabaseService = SupabaseService();
  SupabaseClient get _client => SupabaseService.client;

  // Initialize the service
  Future<void> initialize() async {
    SupabaseService.client; // Ensure Supabase is initialized
  }

  // Get current user
  User? get currentUser => _client.auth.currentUser;
  Session? get currentSession => _client.auth.currentSession;
  bool get isAuthenticated => currentUser != null;

  // Get current user (async method for compatibility)
  Future<User?> getCurrentUser() async {
    return currentUser;
  }

  // Auth state stream
  Stream<AuthState> get authStateStream => _client.auth.onAuthStateChange;

  // Sign up with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String role = 'agent',
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
        },
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      throw Exception('Google sign-in failed: $error');
    }
  }

  // Sign in with Apple OAuth
  Future<bool> signInWithApple() async {
    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.apple);
    } catch (error) {
      throw Exception('Apple sign-in failed: $error');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Update password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      return response;
    } catch (error) {
      throw Exception('Password update failed: $error');
    }
  }

  // Update user profile
  Future<UserResponse> updateProfile({
    String? fullName,
    String? phone,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (fullName != null) data['full_name'] = fullName;
      if (phone != null) data['phone'] = phone;

      final response = await _client.auth.updateUser(
        UserAttributes(data: data),
      );
      return response;
    } catch (error) {
      throw Exception('Profile update failed: $error');
    }
  }

  // Refresh session
  Future<AuthResponse> refreshSession() async {
    try {
      final response = await _client.auth.refreshSession();
      return response;
    } catch (error) {
      throw Exception('Session refresh failed: $error');
    }
  }

  // Get user profile from database
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (!isAuthenticated) return null;

    try {
      final response = await _client
          .from('user_profiles')
          .select('*')
          .eq('id', currentUser!.id)
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to fetch user profile: $error');
    }
  }

  // Update user profile in database
  Future<void> updateUserProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? profileImageUrl,
  }) async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      final Map<String, dynamic> updates = {};
      if (fullName != null) updates['full_name'] = fullName;
      if (phone != null) updates['phone'] = phone;
      if (companyName != null) updates['company_name'] = companyName;
      if (profileImageUrl != null)
        updates['profile_image_url'] = profileImageUrl;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', currentUser!.id);
    } catch (error) {
      throw Exception('Failed to update user profile: $error');
    }
  }

  // Check if user has specific role
  Future<bool> hasRole(String role) async {
    if (!isAuthenticated) return false;

    try {
      final response = await _client
          .from('user_profiles')
          .select('role')
          .eq('id', currentUser!.id)
          .single();
      return response['role'] == role;
    } catch (error) {
      return false;
    }
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    if (!isAuthenticated) throw Exception('User not authenticated');

    try {
      final response = await _client
          .from('user_profiles')
          .select('total_jobs, total_spent')
          .eq('id', currentUser!.id)
          .single();
      return response;
    } catch (error) {
      throw Exception('Failed to fetch user stats: $error');
    }
  }
}
