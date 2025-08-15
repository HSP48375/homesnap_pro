import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class TutorialSearch extends StatefulWidget {
  final bool isLight;
  final Function(String) onSearchChanged;

  const TutorialSearch({
    super.key,
    required this.isLight,
    required this.onSearchChanged,
  });

  @override
  State<TutorialSearch> createState() => _TutorialSearchState();
}

class _TutorialSearchState extends State<TutorialSearch> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _popularSearches = [
    'Camera Settings',
    'Interior Photography',
    'Floorplan Recording',
    'Lighting Tips',
    'Composition Rules',
    'App Navigation',
    'Staging Tips',
    'Common Mistakes',
  ];

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: 90.w,
      padding: EdgeInsets.all(6.w),
      isLight: widget.isLight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Tutorials',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: widget.isLight ? AppTheme.black : AppTheme.white,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(
                  Icons.close,
                  color: widget.isLight ? AppTheme.black : AppTheme.white,
                  size: 6.w,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.w),

          // Search input
          Container(
            decoration: BoxDecoration(
              color: widget.isLight
                  ? AppTheme.white.withAlpha(204)
                  : AppTheme.black.withAlpha(204),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.isLight
                    ? AppTheme.borderSubtle
                    : AppTheme.textSecondaryDark,
              ),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              style: GoogleFonts.poppins(
                color: widget.isLight ? AppTheme.black : AppTheme.white,
              ),
              decoration: InputDecoration(
                hintText: 'Search tutorials, topics, or techniques...',
                hintStyle: GoogleFonts.poppins(
                  color: widget.isLight
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryDark,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: widget.isLight
                      ? AppTheme.textSecondary
                      : AppTheme.textSecondaryDark,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: Icon(
                          Icons.clear,
                          color: widget.isLight
                              ? AppTheme.textSecondary
                              : AppTheme.textSecondaryDark,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 4.w),
              ),
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) {
                widget.onSearchChanged(value);
              },
            ),
          ),
          SizedBox(height: 4.w),

          // Popular searches
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular Searches',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: widget.isLight ? AppTheme.black : AppTheme.white,
              ),
            ),
          ),
          SizedBox(height: 2.w),

          Wrap(
            spacing: 2.w,
            runSpacing: 2.w,
            children: _popularSearches.map((search) {
              return GestureDetector(
                onTap: () => widget.onSearchChanged(search),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.w),
                  decoration: BoxDecoration(
                    color: AppTheme.yellow.withAlpha(51),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.yellow),
                  ),
                  child: Text(
                    search,
                    style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: widget.isLight ? AppTheme.black : AppTheme.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4.w),

          // Search button
          GestureDetector(
            onTap: () => widget.onSearchChanged(_searchController.text),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4.w),
              decoration: BoxDecoration(
                color: AppTheme.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Search Tutorials',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
