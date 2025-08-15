import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class PropertyService {
  final SupabaseService _supabaseService = SupabaseService();
  SupabaseClient get _client => SupabaseService.client;

  // Initialize the service
  Future<void> initialize() async {
    SupabaseService.client; // Ensure Supabase is initialized
  }

  // Create a new property
  Future<Map<String, dynamic>> createProperty({
    required String address,
    required String city,
    required String state,
    required String zipCode,
    String propertyType = 'residential',
    int? squareFeet,
    int? bedrooms,
    double? bathrooms,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final response = await _client
          .from('properties')
          .insert({
            'owner_id': currentUser.id,
            'address': address,
            'city': city,
            'state': state,
            'zip_code': zipCode,
            'property_type': propertyType,
            'square_feet': squareFeet,
            'bedrooms': bedrooms,
            'bathrooms': bathrooms,
          })
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to create property: $error');
    }
  }

  // Get user's properties
  Future<List<Map<String, dynamic>>> getUserProperties({
    int limit = 50,
    int offset = 0,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final response = await _client
          .from('properties')
          .select('''
            *,
            jobs(id, status, total_amount, created_at)
          ''')
          .eq('owner_id', currentUser.id)
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch properties: $error');
    }
  }

  // Get property by ID
  Future<Map<String, dynamic>?> getPropertyById(String propertyId) async {
    try {
      final response = await _client.from('properties').select('''
            *,
            jobs(*, photos(thumbnail_url))
          ''').eq('id', propertyId).single();

      return response;
    } catch (error) {
      throw Exception('Failed to fetch property details: $error');
    }
  }

  // Update property information
  Future<void> updateProperty(
      String propertyId, Map<String, dynamic> updates) async {
    try {
      await _client.from('properties').update(updates).eq('id', propertyId);
    } catch (error) {
      throw Exception('Failed to update property: $error');
    }
  }

  // Delete a property
  Future<void> deleteProperty(String propertyId) async {
    try {
      await _client.from('properties').delete().eq('id', propertyId);
    } catch (error) {
      throw Exception('Failed to delete property: $error');
    }
  }

  // Search properties by address
  Future<List<Map<String, dynamic>>> searchProperties(String query) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      final response = await _client
          .from('properties')
          .select('*')
          .eq('owner_id', currentUser.id)
          .ilike('address', '%$query%')
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to search properties: $error');
    }
  }

  // Get properties by city/state
  Future<List<Map<String, dynamic>>> getPropertiesByLocation({
    String? city,
    String? state,
    int limit = 20,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      var query =
          _client.from('properties').select('*').eq('owner_id', currentUser.id);

      if (city != null) {
        query = query.ilike('city', '%$city%');
      }

      if (state != null) {
        query = query.eq('state', state);
      }

      final response =
          await query.order('created_at', ascending: false).limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch properties by location: $error');
    }
  }

  // Get property statistics
  Future<Map<String, dynamic>> getPropertyStats(String propertyId) async {
    try {
      // Run multiple queries in parallel
      final results = await Future.wait<dynamic>([
        // Total jobs for this property
        _client.from('jobs').select().eq('property_id', propertyId).count(),

        // Completed jobs
        _client
            .from('jobs')
            .select()
            .eq('property_id', propertyId)
            .eq('status', 'completed')
            .count(),

        // Total photos
        _client.rpc('get_property_photo_count',
            params: {'property_uuid': propertyId}),

        // Total spent on this property
        _client
            .from('jobs')
            .select('total_amount')
            .eq('property_id', propertyId)
            .eq('status', 'completed'),
      ]);

      final totalJobs = results[0].count ?? 0;
      final completedJobs = results[1].count ?? 0;
      final totalPhotos = results[2] ?? 0;
      final jobAmounts = results[3] as List<dynamic>;

      final totalSpent = jobAmounts.fold<double>(
          0.0, (sum, job) => sum + (job['total_amount'] as num).toDouble());

      return {
        'total_jobs': totalJobs,
        'completed_jobs': completedJobs,
        'total_photos': totalPhotos,
        'total_spent': totalSpent,
        'average_job_cost': totalJobs > 0 ? totalSpent / totalJobs : 0.0,
      };
    } catch (error) {
      throw Exception('Failed to fetch property statistics: $error');
    }
  }

  // Get recently added properties
  Future<List<Map<String, dynamic>>> getRecentProperties(
      {int limit = 5}) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _client
          .from('properties')
          .select('id, address, city, state, created_at')
          .eq('owner_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch recent properties: $error');
    }
  }

  // Check if address already exists for user
  Future<bool> addressExists(String address) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return false;

      final response = await _client
          .from('properties')
          .select('id')
          .eq('owner_id', currentUser.id)
          .eq('address', address)
          .count();

      return (response.count ?? 0) > 0;
    } catch (error) {
      return false;
    }
  }
}
