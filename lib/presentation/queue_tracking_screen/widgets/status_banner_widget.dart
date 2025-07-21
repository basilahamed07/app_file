import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatusBannerWidget extends StatelessWidget {
  final String status;
  final String message;

  const StatusBannerWidget({
    super.key,
    required this.status,
    required this.message,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'ready':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'next':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'waiting':
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  IconData _getStatusIcon() {
    switch (status.toLowerCase()) {
      case 'ready':
        return Icons.check_circle;
      case 'next':
        return Icons.schedule;
      case 'waiting':
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: _getStatusColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getStatusIcon().codePoint.toString(),
            color: _getStatusColor(),
            size: 6.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.toUpperCase(),
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
