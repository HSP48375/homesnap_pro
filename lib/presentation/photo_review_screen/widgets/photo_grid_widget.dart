import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


class PhotoGridWidget extends StatelessWidget {
  final List<String> photos;
  final Function(int) onPhotoTap;
  final Function(int) onPhotoDelete;

  const PhotoGridWidget({
    super.key,
    required this.photos,
    required this.onPhotoTap,
    required this.onPhotoDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photoPath = photos[index];

        return GestureDetector(
          onTap: () => onPhotoTap(index),
          child: Stack(
            children: [
              // Photo Thumbnail
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildPhotoWidget(photoPath),
                ),
              ),

              // Delete Button
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => onPhotoDelete(index),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(204),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),

              // Photo Index
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoWidget(String photoPath) {
    try {
      return Image.file(
        File(photoPath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[800],
            child: const Icon(
              Icons.broken_image,
              color: Colors.white54,
              size: 32,
            ),
          );
        },
      );
    } catch (e) {
      return Container(
        color: Colors.grey[800],
        child: const Icon(
          Icons.broken_image,
          color: Colors.white54,
          size: 32,
        ),
      );
    }
  }
}
