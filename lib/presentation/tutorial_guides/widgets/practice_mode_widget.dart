import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:camera/camera.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class PracticeModeWidget extends StatefulWidget {
  final bool isLight;
  final VoidCallback onClose;

  const PracticeModeWidget({
    super.key,
    required this.isLight,
    required this.onClose,
  });

  @override
  State<PracticeModeWidget> createState() => _PracticeModeWidgetState();
}

class _PracticeModeWidgetState extends State<PracticeModeWidget> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraReady = false;
  bool _showGuidance = true;
  String _currentGuidance = 'Hold your device steady and frame your subject';
  List<String> _feedbackMessages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );

        await _cameraController!.initialize();
        if (mounted) {
          setState(() {
            _isCameraReady = true;
          });
          _startGuidanceTimer();
        }
      }
    } catch (e) {
      debugPrint('Camera initialization failed: $e');
      _showFeedback('Camera not available. Please check permissions.');
    }
  }

  void _startGuidanceTimer() {
    final guidanceMessages = [
      'Hold your device steady and frame your subject',
      'Check your lighting - natural light works best',
      'Apply the rule of thirds for better composition',
      'Keep your camera level with the horizon',
      'Move closer or farther to get the perfect frame',
    ];

    int currentIndex = 0;
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _updateGuidance(guidanceMessages, currentIndex);
      }
    });
  }

  void _updateGuidance(List<String> messages, int index) {
    if (!mounted) return;

    setState(() {
      _currentGuidance = messages[index % messages.length];
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _updateGuidance(messages, index + 1);
      }
    });
  }

  void _showFeedback(String message) {
    setState(() {
      _feedbackMessages.add(message);
      if (_feedbackMessages.length > 3) {
        _feedbackMessages.removeAt(0);
      }
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _feedbackMessages.contains(message)) {
        setState(() {
          _feedbackMessages.remove(message);
        });
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_cameraController?.value.isInitialized == true) {
      try {
        final XFile image = await _cameraController!.takePicture();
        _analyzePhoto(image);
      } catch (e) {
        _showFeedback('Failed to capture photo');
      }
    }
  }

  void _analyzePhoto(XFile image) {
    // Simulated photo analysis with feedback
    final analysisResults = [
      'Great composition! Nice use of the rule of thirds.',
      'Good lighting balance in this shot.',
      'Try getting a bit closer to your subject.',
      'Excellent framing - this looks professional!',
      'Consider adjusting the angle slightly.',
    ];

    final randomFeedback = (analysisResults..shuffle()).first;
    _showFeedback(randomFeedback);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95.h,
      child: GlassmorphicContainer(
        padding: EdgeInsets.zero,
        isLight: widget.isLight,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildCameraPreview(),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onClose,
            child: Icon(
              Icons.close,
              color: widget.isLight ? AppTheme.black : AppTheme.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Practice Mode',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: widget.isLight ? AppTheme.black : AppTheme.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _showGuidance = !_showGuidance;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.w),
              decoration: BoxDecoration(
                color: _showGuidance ? AppTheme.yellow : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.yellow),
              ),
              child: Text(
                'Guidance',
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: _showGuidance ? AppTheme.black : AppTheme.yellow,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        // Camera preview
        if (_isCameraReady && _cameraController?.value.isInitialized == true)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_cameraController!),
          )
        else
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppTheme.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.yellow),
                  SizedBox(height: 4.w),
                  Text(
                    'Initializing camera...',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppTheme.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Grid overlay (rule of thirds)
        if (_isCameraReady)
          Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
              painter: GridOverlayPainter(),
            ),
          ),

        // Guidance overlay
        if (_showGuidance && _isCameraReady)
          Positioned(
            top: 4.w,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.black.withAlpha(204),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _currentGuidance,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // Feedback messages
        Positioned(
          bottom: 15.h,
          left: 4.w,
          right: 4.w,
          child: Column(
            children: _feedbackMessages
                .map((message) => Container(
                      margin: EdgeInsets.only(bottom: 2.w),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        message,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
        ),

        // Capture button
        Positioned(
          bottom: 4.w,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _capturePhoto,
              child: Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.yellow,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.white,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.camera,
                  color: AppTheme.black,
                  size: 8.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.grid_on,
            label: 'Grid',
            isActive: true,
            onTap: () {},
          ),
          _buildControlButton(
            icon: Icons.wb_sunny,
            label: 'Light',
            isActive: false,
            onTap: () {},
          ),
          _buildControlButton(
            icon: Icons.help_outline,
            label: 'Focus',
            isActive: false,
            onTap: () {},
          ),
          _buildControlButton(
            icon: Icons.help_outline,
            label: 'Tips',
            isActive: _showGuidance,
            onTap: () {
              setState(() {
                _showGuidance = !_showGuidance;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.yellow : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppTheme.yellow
                : (widget.isLight
                    ? AppTheme.borderSubtle
                    : AppTheme.textSecondaryDark),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppTheme.black
                  : (widget.isLight
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryDark),
              size: 5.w,
            ),
            SizedBox(height: 1.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppTheme.black
                    : (widget.isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.white.withAlpha(128)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Vertical lines
    canvas.drawLine(
      Offset(size.width / 3, 0),
      Offset(size.width / 3, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 2 / 3, 0),
      Offset(size.width * 2 / 3, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, size.height / 3),
      Offset(size.width, size.height / 3),
      paint,
    );
    canvas.drawLine(
      Offset(0, size.height * 2 / 3),
      Offset(size.width, size.height * 2 / 3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
