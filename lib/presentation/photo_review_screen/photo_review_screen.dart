
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/photo_grid_widget.dart';
import './widgets/photo_viewer_widget.dart';

class PhotoReviewScreen extends StatefulWidget {
  const PhotoReviewScreen({super.key});

  @override
  State<PhotoReviewScreen> createState() => _PhotoReviewScreenState();
}

class _PhotoReviewScreenState extends State<PhotoReviewScreen> {
  List<String> _photos = [];
  int? _selectedPhotoIndex;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is List<String>) {
      setState(() {
        _photos = List.from(arguments);
      });
    }
  }

  void _viewPhoto(int index) {
    setState(() {
      _selectedPhotoIndex = index;
    });
  }

  void _closePhotoViewer() {
    setState(() {
      _selectedPhotoIndex = null;
    });
  }

  void _deletePhoto(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _photos.removeAt(index);
                if (_selectedPhotoIndex == index) {
                  _selectedPhotoIndex = null;
                } else if (_selectedPhotoIndex != null &&
                    _selectedPhotoIndex! > index) {
                  _selectedPhotoIndex = _selectedPhotoIndex! - 1;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _continueToServices() {
    if (_photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture at least one photo before continuing'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.addOnServices,
      arguments: _photos,
    );
  }

  void _captureMorePhotos() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Photo Review',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_photos.length} photos captured',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: _captureMorePhotos,
                      child: Text(
                        'Add More',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Photo Grid
              Expanded(
                child: _photos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 64,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No photos yet',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 18.sp,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Go back to capture some photos',
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : PhotoGridWidget(
                        photos: _photos,
                        onPhotoTap: _viewPhoto,
                        onPhotoDelete: _deletePhoto,
                      ),
              ),

              // Bottom Actions
              Container(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                  top: 16,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _captureMorePhotos,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Capture More',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _continueToServices,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Continue (${_photos.length})',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Photo Viewer Overlay
          if (_selectedPhotoIndex != null)
            PhotoViewerWidget(
              photos: _photos,
              initialIndex: _selectedPhotoIndex!,
              onClose: _closePhotoViewer,
              onDelete: () {
                _deletePhoto(_selectedPhotoIndex!);
                _closePhotoViewer();
              },
            ),
        ],
      ),
    );
  }
}
