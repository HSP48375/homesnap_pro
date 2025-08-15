import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BlurredBackgroundWidget extends StatelessWidget {
  final String? imageUrl;
  final double blurIntensity;
  final Widget? child;
  final Color? overlayColor;

  const BlurredBackgroundWidget({
    Key? key,
    this.imageUrl,
    this.blurIntensity = 8.0,
    this.child,
    this.overlayColor,
  }) : super(key: key);

  // High-quality home interior/exterior images
  static const List<String> _defaultBackgrounds = [
    'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', // Modern living room
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', // Kitchen interior
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', // Modern house exterior
    'https://images.unsplash.com/photo-1484154218962-a197022b5858?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', // Beautiful bedroom
    'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3', // Luxury house exterior
  ];

  @override
  Widget build(BuildContext context) {
    final selectedImage = imageUrl ?? _getRandomBackground();

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: selectedImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFFD700),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black,
              child: const Center(
                child: Icon(
                  Icons.home,
                  size: 100,
                  color: Color(0xFFFFD700),
                ),
              ),
            ),
          ),
        ),

        // Blur effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurIntensity,
              sigmaY: blurIntensity,
            ),
            child: Container(
              color: overlayColor ?? Colors.black.withAlpha(77),
            ),
          ),
        ),

        // Child content
        if (child != null) child!,
      ],
    );
  }

  String _getRandomBackground() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final index = currentTime % _defaultBackgrounds.length;
    return _defaultBackgrounds[index];
  }
}
