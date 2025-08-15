import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class JobService {
  final SupabaseService _supabaseService = SupabaseService();
  SupabaseClient get _client => SupabaseService.client;

  // Initialize the service
  Future<void> initialize() async {
    SupabaseService.client; // Ensure Supabase is initialized
  }

  // Create a new job
  Future<Map<String, dynamic>> createJob({
    required String propertyId,
    required List<Map<String, dynamic>> services,
    required double totalAmount,
    String? specialInstructions,
    int turnaroundTime = 16,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      // Create the job
      final jobResponse = await _client
          .from('jobs')
          .insert({
            'user_id': currentUser.id,
            'property_id': propertyId,
            'total_amount': totalAmount,
            'special_instructions': specialInstructions,
            'turnaround_time': turnaroundTime,
            'status': 'pending',
          })
          .select()
          .single();

      final jobId = jobResponse['id'];

      // Add services to the job
      for (final service in services) {
        await _client.from('job_services').insert({
          'job_id': jobId,
          'service_type': service['type'],
          'quantity': service['quantity'],
          'unit_price': service['unit_price'],
          'total_price': service['total_price'],
        });
      }

      return jobResponse;
    } catch (error) {
      throw Exception('Failed to create job: $error');
    }
  }

  // Get user's jobs
  Future<List<Map<String, dynamic>>> getUserJobs({
    String? status,
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      var query = _client.from('jobs').select('''
            *,
            properties!inner(address, city, state),
            job_services(service_type, quantity, unit_price, total_price),
            photos(id, file_name, thumbnail_url, room_type, is_processed)
          ''').eq('user_id', currentUser.id);

      if (status != null) {
        query = query.eq('status', status);
      }

      final response = await query
          .order('created_at', ascending: false)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch jobs: $error');
    }
  }

  // Get recent jobs for dashboard
  Future<List<Map<String, dynamic>>> getRecentJobs({int limit = 5}) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) return [];

      final response = await _client
          .from('jobs')
          .select('''
            id,
            status,
            total_amount,
            total_photos,
            created_at,
            properties!inner(address, city, state),
            photos(thumbnail_url)
          ''')
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (error) {
      throw Exception('Failed to fetch recent jobs: $error');
    }
  }

  // Get job details by ID
  Future<Map<String, dynamic>?> getJobById(String jobId) async {
    try {
      final response = await _client.from('jobs').select('''
            *,
            properties!inner(*),
            job_services(*),
            photos(*),
            payments(*)
          ''').eq('id', jobId).single();

      return response;
    } catch (error) {
      throw Exception('Failed to fetch job details: $error');
    }
  }

  // Update job status
  Future<void> updateJobStatus(String jobId, String status) async {
    try {
      final updates = {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (status == 'completed') {
        updates['completed_at'] = DateTime.now().toIso8601String();
      } else if (status == 'delivered') {
        updates['delivered_at'] = DateTime.now().toIso8601String();
      }

      await _client.from('jobs').update(updates).eq('id', jobId);
    } catch (error) {
      throw Exception('Failed to update job status: $error');
    }
  }

  // Add photos to a job
  Future<void> addPhotosToJob(
      String jobId, List<Map<String, dynamic>> photos) async {
    try {
      final photoInserts = photos
          .map((photo) => {
                'job_id': jobId,
                'file_name': photo['file_name'],
                'original_url': photo['original_url'],
                'thumbnail_url': photo['thumbnail_url'],
                'room_type': photo['room_type'],
                'file_size': photo['file_size'],
                'width': photo['width'],
                'height': photo['height'],
              })
          .toList();

      await _client.from('photos').insert(photoInserts);

      // Update total photo count
      await _client.rpc('update_job_photo_count', params: {'job_uuid': jobId});
    } catch (error) {
      throw Exception('Failed to add photos to job: $error');
    }
  }

  // Get job statistics for user
  Future<Map<String, dynamic>> getUserJobStats() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) throw Exception('User not authenticated');

      // Run multiple count queries in parallel
      final results = await Future.wait([
        // Total jobs
        _client
            .from('jobs')
            .select()
            .eq('user_id', currentUser.id)
            .count()
            .then((response) => response),

        // Completed jobs
        _client
            .from('jobs')
            .select()
            .eq('user_id', currentUser.id)
            .eq('status', 'completed')
            .count()
            .then((response) => response),

        // Processing jobs
        _client
            .from('jobs')
            .select()
            .eq('user_id', currentUser.id)
            .eq('status', 'processing')
            .count()
            .then((response) => response),

        // Total spent
        _client
            .from('user_profiles')
            .select('total_spent')
            .eq('id', currentUser.id)
            .single()
            .then((response) => response),
      ]);

      final totalJobs = (results[0] as PostgrestResponse).count ?? 0;
      final completedJobs = (results[1] as PostgrestResponse).count ?? 0;
      final processingJobs = (results[2] as PostgrestResponse).count ?? 0;
      final totalSpent = (results[3] as Map)['total_spent'] ?? 0.0;

      return {
        'total_jobs': totalJobs,
        'completed_jobs': completedJobs,
        'processing_jobs': processingJobs,
        'total_spent': totalSpent,
        'completion_rate':
            totalJobs > 0 ? (completedJobs / totalJobs * 100) : 0.0,
      };
    } catch (error) {
      throw Exception('Failed to fetch job statistics: $error');
    }
  }

  // Subscribe to job status updates
  Stream<List<Map<String, dynamic>>> subscribeToUserJobs() {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) {
      return Stream.empty();
    }

    return _client
        .from('jobs')
        .stream(primaryKey: ['id'])
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false);
  }

  // Delete a job
  Future<void> deleteJob(String jobId) async {
    try {
      await _client.from('jobs').delete().eq('id', jobId);
    } catch (error) {
      throw Exception('Failed to delete job: $error');
    }
  }

  // Get service pricing
  Future<Map<String, dynamic>> getServicePricing() async {
    try {
      // This could be from a pricing table or hardcoded for now
      return {
        'basic_photos': 5.99,
        'virtual_staging': 92.17,
        'object_removal': 15.00,
        'hdr_enhancement': 1.00,
        'drone_photos': 25.00,
        'floor_plan': 45.00,
      };
    } catch (error) {
      throw Exception('Failed to fetch service pricing: $error');
    }
  }
}
