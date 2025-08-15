import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/glassmorphic_container_widget.dart';

class FilterBarWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterBarWidget({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  final List<String> _filters = const [
    'All',
    'Active',
    'Complete',
    'Processing'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == selectedFilter;

          return Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: GlassmorphicContainer(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              opacity: isSelected ? 0.1 : 0.05,
              onTap: () => onFilterChanged(filter),
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppTheme.yellow,
                        borderRadius: BorderRadius.circular(12.0),
                      )
                    : null,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Center(
                  child: Text(
                    filter,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color:
                          isSelected ? AppTheme.black : AppTheme.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
