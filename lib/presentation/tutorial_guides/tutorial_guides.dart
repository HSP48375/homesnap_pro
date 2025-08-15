import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../theme/app_theme.dart';
import '../../widgets/glassmorphic_container_widget.dart';
import './widgets/tutorial_bookmarks_widget.dart';
import './widgets/tutorial_category_card_widget.dart';
import './widgets/tutorial_progress_widget.dart';
import './widgets/tutorial_search_widget.dart';
import './widgets/video_tutorial_widget.dart';

class TutorialGuides extends StatefulWidget {
  const TutorialGuides({super.key});

  @override
  State<TutorialGuides> createState() => _TutorialGuidesState();
}

class _TutorialGuidesState extends State<TutorialGuides>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _searchQuery = '';
  int _selectedCategoryIndex = -1;
  bool _showNewBadge = true;
  List<TutorialCategory> _tutorialCategories = [];
  List<Tutorial> _bookmarkedTutorials = [];
  Map<String, double> _tutorialProgress = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _initializeTutorials();
    _animationController.forward();
  }

  void _initializeTutorials() {
    _tutorialCategories = [
      TutorialCategory(
        id: 'camera_basics',
        title: 'Camera Basics',
        description: 'Master your camera settings and techniques',
        icon: Icons.camera_alt,
        color: AppTheme.yellow,
        estimatedTime: '15 min',
        difficultyLevel: 'Beginner',
        tutorials: [
          Tutorial(
            id: 'camera_settings',
            title: 'Camera Settings & Controls',
            description:
                'Learn essential camera settings for property photography',
            duration: '5 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            isNew: true,
          ),
          Tutorial(
            id: 'lighting_basics',
            title: 'Understanding Natural Light',
            description:
                'How to use natural light for stunning property photos',
            duration: '6 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
            isNew: false,
          ),
          Tutorial(
            id: 'composition_rules',
            title: 'Composition Rules & Techniques',
            description: 'Apply rule of thirds and leading lines effectively',
            duration: '4 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
            isNew: true,
          ),
        ],
      ),
      TutorialCategory(
        id: 'property_photography',
        title: 'Property Photography',
        description: 'Professional tips for interior and exterior shots',
        icon: Icons.home,
        color: AppTheme.black,
        estimatedTime: '25 min',
        difficultyLevel: 'Intermediate',
        tutorials: [
          Tutorial(
            id: 'interior_photography',
            title: 'Interior Photography Techniques',
            description:
                'Capture beautiful interior spaces with proper staging',
            duration: '8 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            isNew: false,
          ),
          Tutorial(
            id: 'exterior_shots',
            title: 'Exterior & Curb Appeal',
            description: 'Showcase property exteriors and landscaping',
            duration: '7 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
            isNew: true,
          ),
          Tutorial(
            id: 'detail_captures',
            title: 'Detail & Feature Photography',
            description: 'Highlight unique features and selling points',
            duration: '5 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
            isNew: false,
          ),
          Tutorial(
            id: 'staging_tips',
            title: 'Staging for Photography',
            description: 'Prepare spaces for optimal visual appeal',
            duration: '5 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            isNew: true,
          ),
        ],
      ),
      TutorialCategory(
        id: 'floorplan_recording',
        title: 'Floorplan Recording',
        description: 'Step-by-step video recording for accurate floorplans',
        icon: Icons.architecture,
        color: AppTheme.textSecondary,
        estimatedTime: '20 min',
        difficultyLevel: 'Advanced',
        tutorials: [
          Tutorial(
            id: 'recording_technique',
            title: 'Proper Recording Technique',
            description: 'Learn the correct way to record walkthrough videos',
            duration: '10 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
            isNew: true,
          ),
          Tutorial(
            id: 'room_visualization',
            title: '3D Room Visualization Tips',
            description: 'Capture room dimensions and layouts effectively',
            duration: '7 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
            isNew: true,
          ),
          Tutorial(
            id: 'common_mistakes',
            title: 'Common Mistakes Prevention',
            description: 'Avoid typical errors in floorplan recording',
            duration: '3 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            isNew: false,
          ),
        ],
      ),
      TutorialCategory(
        id: 'app_features',
        title: 'App Features',
        description: 'Master all HomeSnap Pro app functionality',
        icon: Icons.smartphone,
        color: AppTheme.yellow,
        estimatedTime: '18 min',
        difficultyLevel: 'Beginner',
        tutorials: [
          Tutorial(
            id: 'navigation_basics',
            title: 'App Navigation & Interface',
            description: 'Navigate the app efficiently and use all features',
            duration: '6 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_2mb.mp4',
            isNew: false,
          ),
          Tutorial(
            id: 'job_management',
            title: 'Job Creation & Management',
            description: 'Create, track, and manage photography jobs',
            duration: '8 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_5mb.mp4',
            isNew: true,
          ),
          Tutorial(
            id: 'advanced_features',
            title: 'Advanced App Features',
            description: 'Utilize advanced tools and settings',
            duration: '4 min',
            videoUrl:
                'https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4',
            isNew: true,
          ),
        ],
      ),
    ];

    // Initialize progress tracking
    _tutorialProgress = {};
    for (var category in _tutorialCategories) {
      for (var tutorial in category.tutorials) {
        _tutorialProgress[tutorial.id] = 0.0;
      }
    }
  }

  List<Tutorial> get _filteredTutorials {
    if (_searchQuery.isEmpty && _selectedCategoryIndex == -1) {
      return _tutorialCategories
          .expand((category) => category.tutorials)
          .toList();
    }

    List<Tutorial> filtered = [];
    if (_selectedCategoryIndex != -1) {
      filtered = _tutorialCategories[_selectedCategoryIndex].tutorials;
    } else {
      filtered =
          _tutorialCategories.expand((category) => category.tutorials).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((tutorial) =>
              tutorial.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              tutorial.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isLight),
            _buildTabBar(isLight),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllTutorialsTab(isLight),
                  _buildCategoriesTab(isLight),
                  _buildProgressTab(isLight),
                  _buildBookmarksTab(isLight),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLight) {
    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      child: Row(
        children: [
          GlassmorphicContainer(
            width: 12.w,
            height: 12.w,
            padding: EdgeInsets.zero,
            isLight: isLight,
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: isLight ? AppTheme.black : AppTheme.white,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tutorial Guides',
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: isLight ? AppTheme.black : AppTheme.white,
                      ),
                    ),
                    if (_showNewBadge) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'New!',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Master photography & app features',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          GlassmorphicContainer(
            width: 12.w,
            height: 12.w,
            padding: EdgeInsets.zero,
            isLight: isLight,
            onTap: () => _showSearchDialog(context, isLight),
            child: Icon(
              Icons.search,
              color: isLight ? AppTheme.black : AppTheme.white,
              size: 6.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isLight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: TabBar(
        controller: _tabController,
        labelColor: isLight ? AppTheme.black : AppTheme.white,
        unselectedLabelColor:
            isLight ? AppTheme.textSecondary : AppTheme.textSecondaryDark,
        indicatorColor: AppTheme.yellow,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle:
            GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontSize: 12.sp, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'All Tutorials'),
          Tab(text: 'Categories'),
          Tab(text: 'Progress'),
          Tab(text: 'Bookmarks'),
        ],
      ),
    );
  }

  Widget _buildAllTutorialsTab(bool isLight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3.2,
                mainAxisSpacing: 3.w,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final tutorial = _filteredTutorials[index];
                  return _buildTutorialCard(tutorial, isLight);
                },
                childCount: _filteredTutorials.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab(bool isLight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(4.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 3.w,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = _tutorialCategories[index];
                  return TutorialCategoryCard(
                    category: category,
                    isLight: isLight,
                    onTap: () => _openCategoryTutorials(category),
                  );
                },
                childCount: _tutorialCategories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab(bool isLight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: TutorialProgress(
        tutorialCategories: _tutorialCategories,
        tutorialProgress: _tutorialProgress,
        isLight: isLight,
      ),
    );
  }

  Widget _buildBookmarksTab(bool isLight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: TutorialBookmarks(
        bookmarkedTutorials: _bookmarkedTutorials,
        isLight: isLight,
        onTutorialTap: _openTutorial,
        onRemoveBookmark: _removeBookmark,
      ),
    );
  }

  Widget _buildTutorialCard(Tutorial tutorial, bool isLight) {
    final progress = _tutorialProgress[tutorial.id] ?? 0.0;

    return GlassmorphicContainer(
      padding: EdgeInsets.all(4.w),
      isLight: isLight,
      onTap: () => _openTutorial(tutorial),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 20.w,
                height: 15.w,
                decoration: BoxDecoration(
                  color: AppTheme.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.play_circle_filled,
                  color: AppTheme.black,
                  size: 8.w,
                ),
              ),
              if (tutorial.isNew)
                Positioned(
                  top: -1.w,
                  right: -1.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 1.5.w, vertical: 0.5.w),
                    decoration: BoxDecoration(
                      color: AppTheme.yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'NEW',
                      style: GoogleFonts.poppins(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.black,
                      ),
                    ),
                  ),
                ),
              if (progress > 0)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 0.8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.black.withAlpha(77),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.yellow,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tutorial.title,
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isLight ? AppTheme.black : AppTheme.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.w),
                Text(
                  tutorial.description,
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: isLight
                        ? AppTheme.textSecondary
                        : AppTheme.textSecondaryDark,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.w),
                Text(
                  tutorial.duration,
                  style: GoogleFonts.poppins(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.yellow,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            _bookmarkedTutorials.contains(tutorial)
                ? Icons.bookmark
                : Icons.bookmark_border,
            color: AppTheme.yellow,
            size: 5.w,
          ),
        ],
      ),
    );
  }

  void _showSearchDialog(BuildContext context, bool isLight) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: TutorialSearch(
            isLight: isLight,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
                _selectedCategoryIndex = -1;
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _openCategoryTutorials(TutorialCategory category) {
    final categoryIndex = _tutorialCategories.indexOf(category);
    setState(() {
      _selectedCategoryIndex = categoryIndex;
      _tabController.animateTo(0); // Switch to All Tutorials tab
    });
  }

  void _openTutorial(Tutorial tutorial) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoTutorialWidget(
        tutorial: tutorial,
        isLight: Theme.of(context).brightness == Brightness.light,
        onProgressUpdate: (progress) {
          setState(() {
            _tutorialProgress[tutorial.id] = progress;
          });
        },
        onBookmarkToggle: () => _toggleBookmark(tutorial),
        isBookmarked: _bookmarkedTutorials.contains(tutorial),
      ),
    );
  }

  void _toggleBookmark(Tutorial tutorial) {
    setState(() {
      if (_bookmarkedTutorials.contains(tutorial)) {
        _bookmarkedTutorials.remove(tutorial);
      } else {
        _bookmarkedTutorials.add(tutorial);
      }
    });
  }

  void _removeBookmark(Tutorial tutorial) {
    setState(() {
      _bookmarkedTutorials.remove(tutorial);
    });
  }
}

class TutorialCategory {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String estimatedTime;
  final String difficultyLevel;
  final List<Tutorial> tutorials;

  TutorialCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.estimatedTime,
    required this.difficultyLevel,
    required this.tutorials,
  });
}

class Tutorial {
  final String id;
  final String title;
  final String description;
  final String duration;
  final String videoUrl;
  final bool isNew;

  Tutorial({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.videoUrl,
    required this.isNew,
  });
}
