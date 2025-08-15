import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';
import '../tutorial_guides.dart';

class VideoTutorialWidget extends StatefulWidget {
  final Tutorial tutorial;
  final bool isLight;
  final Function(double) onProgressUpdate;
  final VoidCallback onBookmarkToggle;
  final bool isBookmarked;

  const VideoTutorialWidget({
    super.key,
    required this.tutorial,
    required this.isLight,
    required this.onProgressUpdate,
    required this.onBookmarkToggle,
    required this.isBookmarked,
  });

  @override
  State<VideoTutorialWidget> createState() => _VideoTutorialWidgetState();
}

class _VideoTutorialWidgetState extends State<VideoTutorialWidget> {
  VideoPlayerController? _videoController;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _controlsTimer;
  double _playbackSpeed = 1.0;
  bool _isFullscreen = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  List<TutorialTip> _tips = [];
  int _currentTipIndex = 0;
  bool _practiceMode = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeTips();
  }

  void _initializeVideo() {
    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.tutorial.videoUrl),
      );

      _videoController?.initialize().then((_) {
        if (mounted) {
          setState(() {
            _totalDuration = _videoController!.value.duration;
          });

          _videoController?.addListener(_videoListener);
        }
      }).catchError((error) {
        debugPrint('Video initialization failed: $error');
      });
    } catch (e) {
      debugPrint('Error creating video controller: $e');
    }
  }

  void _initializeTips() {
    // Sample tips based on tutorial content
    _tips = [
      TutorialTip(
        timestamp: const Duration(seconds: 10),
        title: 'Pro Tip',
        content: 'Always check your camera settings before starting',
      ),
      TutorialTip(
        timestamp: const Duration(seconds: 30),
        title: 'Remember',
        content: 'Good lighting is key to professional photos',
      ),
      TutorialTip(
        timestamp: const Duration(seconds: 60),
        title: 'Technique',
        content: 'Keep your phone steady for best results',
      ),
    ];
  }

  void _videoListener() {
    if (_videoController != null && mounted) {
      final position = _videoController!.value.position;
      final duration = _videoController!.value.duration;

      setState(() {
        _currentPosition = position;
        _isPlaying = _videoController!.value.isPlaying;
      });

      // Update progress
      if (duration.inMilliseconds > 0) {
        final progress = position.inMilliseconds / duration.inMilliseconds;
        widget.onProgressUpdate(progress.clamp(0.0, 1.0));
      }

      // Show contextual tips
      _checkForTips(position);
    }
  }

  void _checkForTips(Duration position) {
    for (int i = 0; i < _tips.length; i++) {
      final tip = _tips[i];
      if ((position.inSeconds >= tip.timestamp.inSeconds) &&
          (position.inSeconds < tip.timestamp.inSeconds + 2) &&
          _currentTipIndex <= i) {
        _currentTipIndex = i + 1;
        _showTip(tip);
        break;
      }
    }
  }

  void _showTip(TutorialTip tip) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppTheme.yellow,
              ),
            ),
            Text(
              tip.content,
              style: GoogleFonts.poppins(
                color: AppTheme.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.black.withAlpha(230),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_isPlaying) {
          _videoController!.pause();
        } else {
          _videoController!.play();
        }
        _showControlsTemporarily();
      });
    }
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });

    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _seekTo(Duration position) {
    _videoController?.seekTo(position);
    _showControlsTemporarily();
  }

  void _changePlaybackSpeed() {
    final speeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
    final currentIndex = speeds.indexOf(_playbackSpeed);
    final nextIndex = (currentIndex + 1) % speeds.length;

    setState(() {
      _playbackSpeed = speeds[nextIndex];
      _videoController?.setPlaybackSpeed(_playbackSpeed);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
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
              child:
                  _practiceMode ? _buildPracticeMode() : _buildVideoContent(),
            ),
            _buildBottomControls(),
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
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: widget.isLight ? AppTheme.black : AppTheme.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tutorial.title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: widget.isLight ? AppTheme.black : AppTheme.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.tutorial.duration,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.yellow,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onBookmarkToggle,
            child: Icon(
              widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: AppTheme.yellow,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContent() {
    return Column(
      children: [
        // Video player
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            color: AppTheme.black,
            child: _videoController?.value.isInitialized == true
                ? GestureDetector(
                    onTap: _showControlsTemporarily,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AspectRatio(
                          aspectRatio: _videoController!.value.aspectRatio,
                          child: VideoPlayer(_videoController!),
                        ),
                        if (_showControls) _buildVideoControls(),
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.yellow,
                    ),
                  ),
          ),
        ),

        // Tutorial content
        Expanded(
          flex: 2,
          child: _buildTutorialInfo(),
        ),
      ],
    );
  }

  Widget _buildVideoControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppTheme.black.withAlpha(179),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Play/Pause button
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: AppTheme.black,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 4.w),

          // Progress bar and controls
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  _formatDuration(_currentPosition),
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: AppTheme.white,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppTheme.yellow,
                      inactiveTrackColor: AppTheme.white.withAlpha(77),
                      thumbColor: AppTheme.yellow,
                      overlayColor: AppTheme.yellow.withAlpha(51),
                      trackHeight: 1.w,
                    ),
                    child: Slider(
                      value: _totalDuration.inMilliseconds > 0
                          ? _currentPosition.inMilliseconds /
                              _totalDuration.inMilliseconds
                          : 0.0,
                      onChanged: (value) {
                        final position = Duration(
                          milliseconds:
                              (value * _totalDuration.inMilliseconds).round(),
                        );
                        _seekTo(position);
                      },
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  _formatDuration(_totalDuration),
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: AppTheme.white,
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: _changePlaybackSpeed,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_playbackSpeed}x',
                      style: GoogleFonts.poppins(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialInfo() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About this tutorial',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: widget.isLight ? AppTheme.black : AppTheme.white,
            ),
          ),
          SizedBox(height: 2.w),
          Text(
            widget.tutorial.description,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: widget.isLight
                  ? AppTheme.textSecondary
                  : AppTheme.textSecondaryDark,
            ),
          ),
          SizedBox(height: 4.w),

          // Key learning points
          Text(
            'What you will learn',
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: widget.isLight ? AppTheme.black : AppTheme.white,
            ),
          ),
          SizedBox(height: 2.w),
          ...[
            'Professional camera techniques',
            'Optimal lighting setups',
            'Composition best practices'
          ]
              .map((point) => Container(
                    margin: EdgeInsets.only(bottom: 1.w),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppTheme.yellow,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            point,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: widget.isLight
                                  ? AppTheme.textSecondary
                                  : AppTheme.textSecondaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildPracticeMode() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Text(
            'Practice Mode',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: widget.isLight ? AppTheme.black : AppTheme.white,
            ),
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt,
                    color: AppTheme.yellow,
                    size: 20.w,
                  ),
                  SizedBox(height: 4.w),
                  Text(
                    'Use your camera to practice',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.isLight ? AppTheme.black : AppTheme.white,
                    ),
                  ),
                  Text(
                    'Apply what you learned with real-time feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: widget.isLight
                          ? AppTheme.textSecondary
                          : AppTheme.textSecondaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _practiceMode = !_practiceMode;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.w),
                decoration: BoxDecoration(
                  color: _practiceMode
                      ? AppTheme.yellow
                      : (widget.isLight
                          ? AppTheme.borderSubtle
                          : AppTheme.textSecondaryDark),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _practiceMode ? 'Back to Video' : 'Practice Mode',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: _practiceMode
                        ? AppTheme.black
                        : (widget.isLight ? AppTheme.black : AppTheme.white),
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

class TutorialTip {
  final Duration timestamp;
  final String title;
  final String content;

  TutorialTip({
    required this.timestamp,
    required this.title,
    required this.content,
  });
}
