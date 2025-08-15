import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ServiceDetailModalWidget extends StatefulWidget {
  final Map<String, dynamic> service;
  final bool isSelected;
  final VoidCallback onToggle;

  const ServiceDetailModalWidget({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  State<ServiceDetailModalWidget> createState() =>
      _ServiceDetailModalWidgetState();
}

class _ServiceDetailModalWidgetState extends State<ServiceDetailModalWidget> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<String> additionalImages =
        (widget.service['additionalImages'] as List?)?.cast<String>() ?? [];
    final List<String> allImages = [
      widget.service['beforeImage'] as String,
      widget.service['afterImage'] as String,
      ...additionalImages,
    ];

    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar and header
          Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.service['name'] as String,
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.borderSubtle.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: AppTheme.textSecondary,
                          size: 5.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image carousel
                  Container(
                    height: 30.h,
                    child: PageView.builder(
                      itemCount: allImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CustomImageWidget(
                              imageUrl: allImages[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Image indicators
                  if (allImages.length > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: allImages.asMap().entries.map((entry) {
                        return Container(
                          width: _currentImageIndex == entry.key ? 8.w : 2.w,
                          height: 1.h,
                          margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                          decoration: BoxDecoration(
                            color: _currentImageIndex == entry.key
                                ? AppTheme.accentStart
                                : AppTheme.borderSubtle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }).toList(),
                    ),

                  SizedBox(height: 3.h),

                  // Service description
                  Text(
                    'About This Service',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    widget.service['detailedDescription'] as String? ??
                        widget.service['description'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Features list
                  if (widget.service['features'] != null) ...[
                    Text(
                      'What\'s Included',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(widget.service['features'] as List)
                        .map((feature) => Padding(
                              padding: EdgeInsets.only(bottom: 1.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 0.5.h),
                                    child: CustomIconWidget(
                                      iconName: 'check_circle',
                                      color: AppTheme.successColor,
                                      size: 4.w,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      feature as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    SizedBox(height: 3.h),
                  ],

                  // Pricing and delivery info
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundElevated,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.borderSubtle,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Service Price',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  widget.service['price'] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineSmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.accentStart,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Delivery Time',
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'schedule',
                                      color: AppTheme.textPrimary,
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      widget.service['deliveryTime'] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.service['guarantee'] != null) ...[
                          SizedBox(height: 2.h),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.successColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color: AppTheme.successColor,
                                  size: 5.w,
                                ),
                                SizedBox(width: 2.w),
                                Expanded(
                                  child: Text(
                                    widget.service['guarantee'] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.successColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Bottom action button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderSubtle,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onToggle();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isSelected
                        ? AppTheme.errorColor
                        : AppTheme.accentStart,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    widget.isSelected ? 'Remove Service' : 'Add Service',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.backgroundElevated,
                      fontWeight: FontWeight.w600,
                    ),
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
