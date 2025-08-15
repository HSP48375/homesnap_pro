import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

import './supabase_service.dart';

class PhotoStorageService {
  static final PhotoStorageService _instance = PhotoStorageService._internal();
  factory PhotoStorageService() => _instance;
  PhotoStorageService._internal();

  final SupabaseService _supabaseService = SupabaseService();
  bool _isInitialized = false;

  // Initialize the photo storage service
  Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      // Request permissions on mobile platforms
      if (!kIsWeb) {
        await _requestPermission();
      }

      // Ensure necessary directories exist
      await _ensureDirectoriesExist();

      // Clean up any old temporary files
      await cleanupTempPhotos();

      _isInitialized = true;
      debugPrint('✅ PhotoStorageService initialized successfully');
    } catch (e) {
      debugPrint('❌ Failed to initialize PhotoStorageService: $e');
      // Don't throw - allow app to continue with limited functionality
    }
  }

  // Ensure necessary directories exist
  Future<void> _ensureDirectoriesExist() async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory photoDir = Directory('${appDir.path}/photos');

      if (!await photoDir.exists()) {
        await photoDir.create(recursive: true);
        debugPrint('✅ Photo directory created: ${photoDir.path}');
      }

      final Directory tempDir = await getTemporaryDirectory();
      if (!await tempDir.exists()) {
        await tempDir.create(recursive: true);
        debugPrint('✅ Temp directory ensured: ${tempDir.path}');
      }
    } catch (e) {
      debugPrint('❌ Failed to ensure directories exist: $e');
    }
  }

  // Save photo to device gallery
  Future<bool> saveToGallery(String imagePath) async {
    try {
      if (kIsWeb) {
        debugPrint('Gallery save not supported on web');
        return false;
      }

      // Request permission first
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        debugPrint('Permission denied for gallery access');
        return false;
      }

      // Save to gallery using gal package
      await Gal.putImage(imagePath);
      debugPrint('✅ Photo saved to gallery: $imagePath');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to save photo to gallery: $e');
      return false;
    }
  }

  // Save multiple photos to gallery
  Future<List<bool>> saveMultipleToGallery(List<String> imagePaths) async {
    List<bool> results = [];

    for (String path in imagePaths) {
      final result = await saveToGallery(path);
      results.add(result);
    }

    return results;
  }

  // Request necessary permissions
  Future<bool> _requestPermission() async {
    if (kIsWeb) return true;

    try {
      final PermissionState permission =
          await PhotoManager.requestPermissionExtend();
      return permission == PermissionState.authorized ||
          permission == PermissionState.limited;
    } catch (e) {
      debugPrint('❌ Permission request failed: $e');
      return false;
    }
  }

  // Save photo to app's document directory
  Future<String?> saveToAppDirectory(
      Uint8List imageData, String fileName) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(imageData);

      debugPrint('✅ Photo saved to app directory: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('❌ Failed to save photo to app directory: $e');
      return null;
    }
  }

  // Upload photo to Supabase Storage
  Future<String?> uploadToSupabaseStorage(
      String filePath, String jobId, String fileName) async {
    try {
      final client = SupabaseService.client;
      final File file = File(filePath);

      if (!await file.exists()) {
        debugPrint('❌ File does not exist: $filePath');
        return null;
      }

      final String bucketPath = 'job_photos/$jobId/$fileName';

      // Upload file to Supabase Storage
      await client.storage.from('photos').upload(bucketPath, file);

      // Get public URL
      final String publicUrl =
          client.storage.from('photos').getPublicUrl(bucketPath);

      debugPrint('✅ Photo uploaded to Supabase: $publicUrl');
      return publicUrl;
    } catch (e) {
      debugPrint('❌ Failed to upload photo to Supabase: $e');
      return null;
    }
  }

  // Delete photo from device
  Future<bool> deletePhoto(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        debugPrint('✅ Photo deleted: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('❌ Failed to delete photo: $e');
      return false;
    }
  }

  // Get photos from gallery
  Future<List<AssetEntity>> getPhotosFromGallery(
      {int page = 0, int size = 20}) async {
    try {
      if (kIsWeb) {
        debugPrint('Gallery access not supported on web');
        return [];
      }

      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        debugPrint('Permission denied for gallery access');
        return [];
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      if (albums.isEmpty) return [];

      final List<AssetEntity> photos = await albums.first.getAssetListPaged(
        page: page,
        size: size,
      );

      return photos;
    } catch (e) {
      debugPrint('❌ Failed to get photos from gallery: $e');
      return [];
    }
  }

  // Convert AssetEntity to File
  Future<File?> assetToFile(AssetEntity asset) async {
    try {
      final File? file = await asset.file;
      return file;
    } catch (e) {
      debugPrint('❌ Failed to convert asset to file: $e');
      return null;
    }
  }

  // Get photo file size
  Future<int> getPhotoFileSize(String filePath) async {
    try {
      final File file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
      return 0;
    } catch (e) {
      debugPrint('❌ Failed to get photo file size: $e');
      return 0;
    }
  }

  // Compress photo (basic implementation)
  Future<String?> compressPhoto(String inputPath, {int quality = 85}) async {
    try {
      // For production, you might want to use image compression packages
      // For now, we'll just copy the file as-is
      final File inputFile = File(inputPath);
      if (!await inputFile.exists()) return null;

      final Directory tempDir = await getTemporaryDirectory();
      final String outputPath =
          '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await inputFile.copy(outputPath);
      return outputPath;
    } catch (e) {
      debugPrint('❌ Failed to compress photo: $e');
      return null;
    }
  }

  // Clean up temporary photos
  Future<void> cleanupTempPhotos() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final List<FileSystemEntity> files = tempDir.listSync();

      for (FileSystemEntity file in files) {
        if (file is File && file.path.contains('compressed_')) {
          await file.delete();
        }
      }

      debugPrint('✅ Temporary photos cleaned up');
    } catch (e) {
      debugPrint('❌ Failed to cleanup temporary photos: $e');
    }
  }
}
