import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrustFooterWidget extends StatelessWidget {
  const TrustFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTrustBadge('256-bit', 'lock'),
              SizedBox(width: 6.w),
              _buildTrustBadge('HIPAA', 'verified_user'),
              SizedBox(width: 6.w),
              _buildTrustBadge('ISO 27001', 'security'),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '50,000+ patients trust QueueFree',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                  5,
                  (index) => CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 12,
                      )),
              SizedBox(width: 1.w),
              Text(
                '4.8/5 rating',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrustBadge(String title, String icon) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.secondaryContainer
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 16,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
