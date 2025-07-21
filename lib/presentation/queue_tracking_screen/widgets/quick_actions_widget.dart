import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onCancelToken;
  final VoidCallback? onReschedule;
  final VoidCallback? onCallClinic;
  final VoidCallback? onShareStatus;

  const QuickActionsWidget({
    super.key,
    this.onCancelToken,
    this.onReschedule,
    this.onCallClinic,
    this.onShareStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Cancel Token',
                  Icons.cancel_outlined,
                  AppTheme.lightTheme.colorScheme.error,
                  onCancelToken,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildActionButton(
                  'Reschedule',
                  Icons.schedule,
                  AppTheme.lightTheme.colorScheme.tertiary,
                  onReschedule,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Call Clinic',
                  Icons.phone,
                  AppTheme.lightTheme.colorScheme.secondary,
                  onCallClinic,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildActionButton(
                  'Share Status',
                  Icons.share,
                  AppTheme.lightTheme.colorScheme.primary,
                  onShareStatus,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon.codePoint.toString(),
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
