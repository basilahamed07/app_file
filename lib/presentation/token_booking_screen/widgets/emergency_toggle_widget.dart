import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmergencyToggleWidget extends StatelessWidget {
  final bool isEmergency;
  final Function(bool) onToggleChanged;

  const EmergencyToggleWidget({
    Key? key,
    required this.isEmergency,
    required this.onToggleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isEmergency
            ? AppTheme.lightTheme.colorScheme.errorContainer
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEmergency
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'emergency',
            color: isEmergency
                ? AppTheme.lightTheme.colorScheme.error
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Emergency Booking',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: isEmergency
                        ? AppTheme.lightTheme.colorScheme.onErrorContainer
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isEmergency
                      ? 'Priority booking with additional charges'
                      : 'Get priority in queue (Additional ₹200)',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isEmergency
                        ? AppTheme.lightTheme.colorScheme.onErrorContainer
                            .withValues(alpha: 0.8)
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Switch(
            value: isEmergency,
            onChanged: (value) {
              if (value) {
                _showEmergencyWarning(context);
              } else {
                onToggleChanged(value);
              }
            },
            activeColor: AppTheme.lightTheme.colorScheme.error,
            activeTrackColor: AppTheme.lightTheme.colorScheme.errorContainer,
          ),
        ],
      ),
    );
  }

  void _showEmergencyWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Emergency Booking',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Emergency booking includes:',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 1.h),
              _buildBulletPoint('Priority queue placement'),
              _buildBulletPoint('Additional charge of ₹200'),
              _buildBulletPoint('Immediate notification to doctor'),
              _buildBulletPoint('Non-refundable booking fee'),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Only use for genuine medical emergencies',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onToggleChanged(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.error,
                foregroundColor: AppTheme.lightTheme.colorScheme.onError,
              ),
              child: const Text('Confirm Emergency'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: EdgeInsets.only(top: 1.h, right: 2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
