import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContactPreferencesWidget extends StatefulWidget {
  final List<String> selectedMethods;
  final Function(List<String>) onMethodsChanged;

  const ContactPreferencesWidget({
    super.key,
    required this.selectedMethods,
    required this.onMethodsChanged,
  });

  @override
  State<ContactPreferencesWidget> createState() =>
      _ContactPreferencesWidgetState();
}

class _ContactPreferencesWidgetState extends State<ContactPreferencesWidget> {
  late List<String> _selectedMethods;

  final List<Map<String, dynamic>> _notificationMethods = [
    {
      'id': 'push',
      'name': 'Push Notifications',
      'description': 'Instant updates on your device',
      'icon': 'notifications',
    },
    {
      'id': 'email',
      'name': 'Email Updates',
      'description': 'Detailed progress reports via email',
      'icon': 'email',
    },
    {
      'id': 'sms',
      'name': 'SMS Alerts',
      'description': 'Quick text message updates',
      'icon': 'sms',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethods = List.from(widget.selectedMethods);
  }

  void _toggleMethod(String methodId) {
    setState(() {
      if (_selectedMethods.contains(methodId)) {
        _selectedMethods.remove(methodId);
      } else {
        _selectedMethods.add(methodId);
      }
    });
    widget.onMethodsChanged(_selectedMethods);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Preferences',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'How would you like to receive job updates?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _notificationMethods.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.h),
            itemBuilder: (context, index) {
              final method = _notificationMethods[index];
              final isSelected = _selectedMethods.contains(method['id']);

              return GestureDetector(
                onTap: () => _toggleMethod(method['id'] as String),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.accentStart.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentStart
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: method['icon'] as String,
                        color: isSelected
                            ? AppTheme.accentStart
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 6.w,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleSmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.accentStart
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              method['description'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.accentStart
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.accentStart
                                : AppTheme.lightTheme.colorScheme.outline,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: isSelected
                            ? CustomIconWidget(
                                iconName: 'check',
                                color:
                                    AppTheme.lightTheme.colorScheme.onTertiary,
                                size: 3.w,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
