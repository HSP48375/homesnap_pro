import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../services/supabase_service.dart';
import './widgets/delivery_message_widget.dart';
import './widgets/guidance_overlay_widget.dart';
import './widgets/recording_controls_widget.dart';
import './widgets/room_progress_widget.dart';

class TwoDFloorplanCreator extends StatefulWidget {
  const TwoDFloorplanCreator({super.key});

  @override
  State<TwoDFloorplanCreator> createState() => _TwoDFloorplanCreatorState();
}

class _TwoDFloorplanCreatorState extends State<TwoDFloorplanCreator>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera and recording
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isPaused = false;

  // Recording state
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  String? _videoPath;

  // Room tracking
  int _currentRoom = 1;
  final int _totalRooms = 8;
  final List<String> _roomTypes = [
    'Living Room',
    'Kitchen',
    'Master Bedroom',
    'Bathroom',
    'Dining Room',
    'Bedroom 2',
    'Bedroom 3',
    'Hallway/Other'
  ];

  String get _currentRoomType => _roomTypes[_currentRoom - 1];

  // UI state
  bool _showGuidance = true;
  bool _isUploading = false;
  bool _uploadCompleted = false;
  late AnimationController _pulseController;
  late AnimationController _deliveryController;

  // Guidance messages
  final List<String> _guidanceSteps = [
    'Point camera at floor, walk slowly around perimeter',
    'Keep steady pace, capture all corners clearly',
    'Include doorways and architectural features',
    'Stop recording when room is complete'
  ];

  int _currentGuidanceStep = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _deliveryController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    _recordingTimer?.cancel();
    _pulseController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<bool> _requestPermissions() async {
    if (kIsWeb) return true;

    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    final storageStatus = await Permission.storage.request();

    return cameraStatus.isGranted &&
        microphoneStatus.isGranted &&
        storageStatus.isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestPermissions()) {
        _showPermissionDialog();
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      // Use rear camera for floorplan recording
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: true, // Enable audio for video recording
      );

      await _cameraController!.initialize();
      await _applyInitialSettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      _showCameraErrorDialog();
    }
  }

  Future<void> _applyInitialSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      debugPrint('Settings application error: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Permissions Required',
          style: GoogleFonts.poppins(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Camera, microphone, and storage permissions are required for video recording.',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('No Camera Found'),
        content: Text('No camera is available on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Camera Error'),
        content: Text('Unable to initialize camera. Please try again.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.startVideoRecording();

      setState(() {
        _isRecording = true;
        _isPaused = false;
        _recordingDuration = Duration.zero;
      });

      HapticFeedback.mediumImpact();

      // Start recording timer
      _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_isRecording && !_isPaused) {
          setState(() {
            _recordingDuration = Duration(seconds: timer.tick);
          });
        }
      });

      _showRecordingStartedSnackbar();
    } catch (e) {
      debugPrint('Start recording error: $e');
      _showErrorSnackbar('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();

      setState(() {
        _isRecording = false;
        _isPaused = false;
        _videoPath = videoFile.path;
      });

      _recordingTimer?.cancel();
      HapticFeedback.lightImpact();

      if (_currentRoom < _totalRooms) {
        _showRoomCompletionDialog();
      } else {
        _showAllRoomsCompletedDialog();
      }
    } catch (e) {
      debugPrint('Stop recording error: $e');
      _showErrorSnackbar('Failed to stop recording');
    }
  }

  void _pauseRecording() {
    if (_isRecording) {
      setState(() {
        _isPaused = !_isPaused;
      });

      HapticFeedback.selectionClick();

      if (_isPaused) {
        _showMotionDetectionDialog();
      }
    }
  }

  void _nextRoom() {
    if (_currentRoom < _totalRooms) {
      setState(() {
        _currentRoom++;
        _currentGuidanceStep = 0;
        _recordingDuration = Duration.zero;
      });
    }
  }

  void _completeFloorplan() async {
    setState(() {
      _isUploading = true;
    });

    try {
      // Simulate upload process
      await Future.delayed(Duration(seconds: 3));

      // Create floorplan request in database
      await _createFloorplanRequest();

      setState(() {
        _isUploading = false;
        _uploadCompleted = true;
      });

      _deliveryController.forward();
      _showUploadCompletedDialog();
    } catch (e) {
      debugPrint('Upload error: $e');
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackbar('Upload failed. Please try again.');
    }
  }

  Future<void> _createFloorplanRequest() async {
    try {
      final supabaseClient = SupabaseService.client;
      final currentUser = await AuthService().getCurrentUser();

      if (currentUser != null) {
        await supabaseClient.from('floorplan_requests').insert({
          'user_id': currentUser.id,
          'status': 'uploaded',
          'rooms_recorded': _currentRoom,
          'total_rooms_planned': _totalRooms,
          'video_file_path': _videoPath ?? 'uploaded_video.mp4',
          'special_instructions': 'Video walkthrough recording completed',
        });

        // Create notification
        await supabaseClient.rpc('create_notification', params: {
          'target_user_id': currentUser.id,
          'notification_type': 'floorplan_ready',
          'title': 'Floorplan Upload Complete',
          'message':
              'Your video has been uploaded. Processing will begin shortly.',
          'data': {'delivery_time': '12-14 hours'},
        });
      }
    } catch (e) {
      debugPrint('Database error: $e');
      rethrow;
    }
  }

  void _showRecordingStartedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 2.w),
            Text('Recording ${_currentRoomType}...'),
          ],
        ),
        backgroundColor: AppTheme.backgroundElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showRoomCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.yellow, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'Room Complete!',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          '${_currentRoomType} recording completed. Ready for the next room?',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _completeFloorplan();
            },
            child: Text('Finish Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _nextRoom();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.yellow),
            child: Text('Next Room', style: TextStyle(color: AppTheme.black)),
          ),
        ],
      ),
    );
  }

  void _showAllRoomsCompletedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: AppTheme.yellow, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'All Rooms Complete!',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Congratulations! You have completed recording all ${_totalRooms} rooms. Ready to upload?',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Review First'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeFloorplan();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.yellow),
            child: Text('Upload Now', style: TextStyle(color: AppTheme.black)),
          ),
        ],
      ),
    );
  }

  void _showMotionDetectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.pause_circle, color: AppTheme.yellow, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'Recording Paused',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Text(
          'Motion stopped detected. Continue recording this room or mark as complete?',
          style: GoogleFonts.poppins(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pauseRecording(); // Resume
            },
            child: Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _stopRecording();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.yellow),
            child:
                Text('Room Complete', style: TextStyle(color: AppTheme.black)),
          ),
        ],
      ),
    );
  }

  void _showUploadCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.cloud_upload, color: AppTheme.yellow, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'Upload Complete!',
              style: GoogleFonts.poppins(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your floorplan video has been uploaded successfully.',
              style: GoogleFonts.poppins(color: AppTheme.textSecondary),
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.yellow.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.yellow),
              ),
              child: Row(
                children: [
                  Icon(Icons.schedule, color: AppTheme.yellow, size: 5.w),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Your 2D floorplan will be ready in 12-14 hours',
                      style: GoogleFonts.poppins(
                        color: AppTheme.yellow,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to previous screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.yellow,
              minimumSize: Size(double.infinity, 48),
            ),
            child: Text(
              'Done',
              style:
                  TextStyle(color: AppTheme.black, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.yellow),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview
          Positioned.fill(
            child: _cameraController?.value.isInitialized == true
                ? CameraPreview(_cameraController!)
                : Container(color: Colors.black),
          ),

          // Upload completed overlay
          if (_uploadCompleted)
            DeliveryMessageWidget(
              animationController: _deliveryController,
              isVisible: _uploadCompleted,
            ),

          // Room progress indicator (top)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: RoomProgressWidget(
                currentRoom: _currentRoom,
                totalRooms: _totalRooms,
                currentRoomType: _currentRoomType,
                isRecording: _isRecording,
                isPaused: _isPaused,
                recordingDuration: _recordingDuration,
              ),
            ),
          ),

          // Guidance overlay
          if (_showGuidance && !_uploadCompleted)
            GuidanceOverlayWidget(
              currentStep: _currentGuidanceStep,
              steps: _guidanceSteps,
              currentRoom: _currentRoomType,
              onStepNext: () {
                setState(() {
                  _currentGuidanceStep =
                      (_currentGuidanceStep + 1) % _guidanceSteps.length;
                });
              },
              onClose: () {
                setState(() {
                  _showGuidance = false;
                });
              },
            ),

          // Recording controls (bottom)
          if (!_uploadCompleted)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: RecordingControlsWidget(
                  isRecording: _isRecording,
                  isPaused: _isPaused,
                  recordingDuration: _recordingDuration,
                  currentRoom: _currentRoom,
                  totalRooms: _totalRooms,
                  isUploading: _isUploading,
                  pulseController: _pulseController,
                  onStartRecording: _startRecording,
                  onStopRecording: _stopRecording,
                  onPauseRecording: _pauseRecording,
                  onCompleteFloorplan: _completeFloorplan,
                ),
              ),
            ),

          // Back button
          Positioned(
            top: 6.h,
            left: 4.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),

          // Help button
          Positioned(
            top: 6.h,
            right: 4.w,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _showGuidance = !_showGuidance;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'help_outline',
                    color: AppTheme.black,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
