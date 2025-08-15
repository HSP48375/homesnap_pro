import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/glassmorphic_container_widget.dart';
import './widgets/onboarding_progress_widget.dart';
import './widgets/onboarding_step_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingData> _onboardingSteps = [
    OnboardingData(
      title: "Professional Photography\nMade Simple",
      description:
          "Capture stunning property photos with our AI-guided camera interface. Get professional results every time with real-time composition guides.",
      imageUrl:
          "https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80",
      features: [
        "AI-powered composition guides",
        "Professional lighting analysis",
        "Automatic quality enhancement"
      ],
    ),
    OnboardingData(
      title: "Enhanced Services &\nEditing Tools",
      description:
          "Elevate your listings with premium add-on services including Virtual twilights, realistic virtual staging, measured floorplans, and clutter removal.",
      imageUrl:
          "https://images.pexels.com/photos/259588/pexels-photo-259588.jpeg?auto=compress&cs=tinysrgb&w=1000",
      features: [
        "Virtual staging & twilight shots",
        "HDR & professional editing",
        "Drone & 360° photography"
      ],
    ),
    OnboardingData(
      title: "Track Jobs &\nFast Delivery",
      description:
          "Monitor your projects in real-time with our advanced tracking system. Get professional results delivered within 24-48 hours.",
      imageUrl:
          "https://images.pixabay.com/photo-2016/11/19/14/00/code-1839406_1280.jpg?auto=compress&cs=tinysrgb&w=1000",
      features: [
        "Real-time job tracking",
        "24-48 hour delivery guarantee",
        "Priority customer support"
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingSteps.length - 1) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    HapticFeedback.mediumImpact();
    _completeOnboarding();
  }

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Skip button
          Padding(
            padding: EdgeInsets.only(right: 4.w, top: 2.h),
            child: TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image with glassmorphic overlay
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              HapticFeedback.selectionClick();
            },
            itemCount: _onboardingSteps.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_onboardingSteps[index].imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.black.withAlpha(77),
                        AppTheme.black.withAlpha(179),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Content overlay
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Main content with glassmorphic container
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: OnboardingStepWidget(
                        data: _onboardingSteps[_currentPage],
                      ),
                    ),

                    SizedBox(height: 6.h),

                    // Progress indicator
                    OnboardingProgressWidget(
                      currentPage: _currentPage,
                      totalPages: _onboardingSteps.length,
                    ),

                    SizedBox(height: 4.h),

                    // Next button
                    GlassmorphicContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(0),
                      opacity: 0.1,
                      isLight: false,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.yellow,
                          foregroundColor: AppTheme.black,
                          padding: EdgeInsets.symmetric(vertical: 2.5.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentPage == _onboardingSteps.length - 1
                              ? 'Get Started'
                              : 'Next',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> features;

  OnboardingData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.features,
  });
}
