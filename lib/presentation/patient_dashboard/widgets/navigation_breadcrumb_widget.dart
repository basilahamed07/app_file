import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NavigationBreadcrumbWidget extends StatelessWidget {
  final String currentSection;
  final List<BreadcrumbItem> breadcrumbs;

  const NavigationBreadcrumbWidget({
    Key? key,
    required this.currentSection,
    required this.breadcrumbs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...breadcrumbs.asMap().entries.map((entry) {
                    final index = entry.key;
                    final breadcrumb = entry.value;
                    final isLast = index == breadcrumbs.length - 1;

                    return Row(
                      children: [
                        if (index > 0) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'chevron_right',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 2.w),
                        ],
                        GestureDetector(
                          onTap: isLast ? null : breadcrumb.onTap,
                          child: Text(
                            breadcrumb.title,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: isLast
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight:
                                  isLast ? FontWeight.w600 : FontWeight.w400,
                              decoration:
                                  isLast ? null : TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentSection,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BreadcrumbItem {
  final String title;
  final VoidCallback? onTap;

  BreadcrumbItem({
    required this.title,
    this.onTap,
  });
}
