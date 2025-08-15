import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FocusIndicatorWidget extends StatefulWidget {
  final Offset? focusPoint;
  final bool isVisible;
  final double exposureValue;
  final ValueChanged<double>? onExposureChanged;

  const FocusIndicatorWidget({
    super.key,
    this.focusPoint,
    required this.isVisible,
    required this.exposureValue,
    this.onExposureChanged,
  });

  @override
  State<FocusIndicatorWidget> createState() => _FocusIndicatorWidgetState();
}

class _FocusIndicatorWidgetState extends State<FocusIndicatorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void didUpdateWidget(FocusIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _animationController.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.focusPoint == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: widget.focusPoint!.dx - 50,
      top: widget.focusPoint!.dy - 50,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Focus square
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppTheme.accentStart,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          // Corner indicators
                          Positioned(
                            top: -1,
                            left: -1,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                  left: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -1,
                            right: -1,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            left: -1,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                  left: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            right: -1,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                  right: BorderSide(
                                    color: AppTheme.accentStart,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Exposure slider
                    if (widget.onExposureChanged != null)
                      Positioned(
                        right: -40,
                        child: Container(
                          height: 120,
                          width: 30,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 8,
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 16,
                                ),
                                activeTrackColor: AppTheme.accentStart,
                                inactiveTrackColor:
                                    Colors.white.withValues(alpha: 0.3),
                                thumbColor: AppTheme.accentStart,
                                overlayColor:
                                    AppTheme.accentStart.withValues(alpha: 0.2),
                              ),
                              child: Slider(
                                value: widget.exposureValue,
                                min: -2.0,
                                max: 2.0,
                                divisions: 40,
                                onChanged: widget.onExposureChanged,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
