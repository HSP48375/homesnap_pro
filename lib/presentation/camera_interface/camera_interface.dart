import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/capture_button_widget.dart';
import './widgets/grid_overlay_widget.dart';
import './widgets/professional_guides_widget.dart';
import './widgets/side_controls_widget.dart';

class CameraInterface extends StatefulWidget {
  const CameraInterface({super.key});

  @override
  State<CameraInterface> createState() => _CameraInterfaceState();
}

class _CameraInterfaceState extends State<CameraInterface> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _showGrid = false;
  FlashMode _flashMode = FlashMode.auto;
  List<String> _capturedPhotos = [];
  bool _isBurstMode = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final permission = await _requestCameraPermission();
      if (!permission) {
        _showErrorDialog('Camera permission is required to take photos');
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showErrorDialog('No cameras found on this device');
        return;
      }

      // Initialize camera controller
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
          enableAudio: false);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to initialize camera: ${e.toString()}');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(_flashMode);
      }
    } catch (e) {
      // Silently handle unsupported operations
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      await _savePhotoToGallery(photo);

      _capturedPhotos.add(photo.path);

      // Show capture feedback
      _showCaptureSuccess();
    } catch (e) {
      _showErrorDialog('Failed to capture photo: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _captureBurstPhotos() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _isBurstMode = true;
    });

    try {
      // Capture 5 photos in burst mode
      for (int i = 0; i < 5; i++) {
        final XFile photo = await _cameraController!.takePicture();
        await _savePhotoToGallery(photo);
        _capturedPhotos.add(photo.path);

        // Small delay between captures
        await Future.delayed(const Duration(milliseconds: 200));
      }

      _showCaptureSuccess(burst: true);
    } catch (e) {
      _showErrorDialog('Failed to capture burst photos: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
          _isBurstMode = false;
        });
      }
    }
  }

  Future<void> _savePhotoToGallery(XFile photo) async {
    try {
      if (kIsWeb) {
        // Web doesn't support gallery saving
        return;
      }

      await Gal.putImage(photo.path);
    } catch (e) {
      // Silently handle gallery save failures
    }
  }

  void _showCaptureSuccess({bool burst = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(burst ? 'Burst photos captured!' : 'Photo captured!'),
        duration: const Duration(milliseconds: 800),
        backgroundColor: Colors.green));
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Camera Error'),
                content: Text(message),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK')),
                ]));
  }

  void _toggleFlash() {
    if (kIsWeb) return;

    setState(() {
      switch (_flashMode) {
        case FlashMode.off:
          _flashMode = FlashMode.auto;
          break;
        case FlashMode.auto:
          _flashMode = FlashMode.always;
          break;
        case FlashMode.always:
          _flashMode = FlashMode.off;
          break;
        default:
          _flashMode = FlashMode.auto;
      }
    });
    _applySettings();
  }

  void _toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
    });
  }

  void _navigateToPhotoReview() {
    if (_capturedPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No photos captured yet'),
          backgroundColor: Colors.orange));
      return;
    }

    Navigator.pushNamed(context, AppRoutes.photoReviewScreen,
        arguments: _capturedPhotos);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
          backgroundColor: Colors.black,
          body: const Center(
              child: CircularProgressIndicator(color: Colors.white)));
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(children: [
          // Camera Preview
          Positioned.fill(
              child: CameraPreviewWidget(
            cameraController: _cameraController!,
            aspectRatio: '4:3',
          )),

          // Grid Overlay
          if (_showGrid)
            Positioned.fill(
                child: GridOverlayWidget(
              isVisible: _showGrid,
            )),

          // Professional Guides
          Positioned.fill(
              child: ProfessionalGuidesWidget(
            currentRoom: '',
            isVisible: true,
            onClose: () {},
          )),

          // Top Controls
          Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 16,
              right: 16,
              child: CameraControlsWidget(
                  isBurstMode: _isBurstMode,
                  isFlashOn: _flashMode != FlashMode.off,
                  isGridOn: _showGrid,
                  onBurstToggle: () {},
                  onCameraFlip: () {},
                  onFlashToggle: _toggleFlash,
                  onGridToggle: _toggleGrid)),

          // Side Controls
          Positioned(
              right: 16,
              top: MediaQuery.of(context).size.height * 0.3,
              child: SideControlsWidget(
                aspectRatio: '4:3',
                onAspectRatioChanged: (String ratio) {},
                onInfoTap: () {},
                onZoomChanged: (double zoom) {},
                zoomLevel: 1.0,
              )),

          // Bottom Controls
          Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 32,
              left: 0,
              right: 0,
              child: CaptureButtonWidget(
                  isCapturing: _isCapturing,
                  isBurstMode: _isBurstMode,
                  onCapture: _capturePhoto,
                  onBurstCapture: _captureBurstPhotos)),
        ]));
  }
}
