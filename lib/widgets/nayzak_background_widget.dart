import 'dart:math';
import 'package:flutter/material.dart';

class NayzakBackgroundWidget extends StatefulWidget {
  final Widget child;

  const NayzakBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<NayzakBackgroundWidget> createState() => _NayzakBackgroundWidgetState();
}

class _NayzakBackgroundWidgetState extends State<NayzakBackgroundWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _controller2 = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _controller3 = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Animated gradient blur circles
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              return Positioned(
                left: 50 + (sin(_controller1.value * 2 * pi) * 30),
                top: 100 + (cos(_controller1.value * 2 * pi) * 20),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD700).withAlpha(77),
                        const Color(0xFFFFD700).withAlpha(26),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Positioned(
                right: 30 + (sin(_controller2.value * 2 * pi + pi) * 40),
                top: 250 + (cos(_controller2.value * 2 * pi + pi) * 30),
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD700).withAlpha(64),
                        const Color(0xFFFFD700).withAlpha(20),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.6, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _controller3,
            builder: (context, child) {
              return Positioned(
                left: 120 + (sin(_controller3.value * 2 * pi + pi / 2) * 25),
                bottom: 150 + (cos(_controller3.value * 2 * pi + pi / 2) * 35),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD700).withAlpha(51),
                        const Color(0xFFFFD700).withAlpha(13),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.8, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),

          // Additional subtle circles for depth
          Positioned(
            right: 80,
            bottom: 300,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withAlpha(38),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          Positioned(
            left: 200,
            top: 400,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFFD700).withAlpha(31),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
          ),

          // Child content
          widget.child,
        ],
      ),
    );
  }
}
