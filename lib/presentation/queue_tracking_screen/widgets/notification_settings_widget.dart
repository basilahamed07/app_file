import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final bool fiveTokensAhead;
  final bool nextInLine;
  final bool readyForConsultation;
  final Function(bool) onFiveTokensAheadChanged;
  final Function(bool) onNextInLineChanged;
  final Function(bool) onReadyForConsultationChanged;

  const NotificationSettingsWidget({
    super.key,
    required this.fiveTokensAhead,
    required this.nextInLine,
    required this.readyForConsultation,
    required this.onFiveTokensAheadChanged,
    required this.onNextInLineChanged,
    required this.onReadyForConsultationChanged,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
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
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notification Settings',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildNotificationOption(
            'Alert when 5 tokens ahead',
            'Get notified when you\'re 5 tokens away',
            widget.fiveTokensAhead,
            widget.onFiveTokensAheadChanged,
          ),
          SizedBox(height: 1.h),
          _buildNotificationOption(
            'Alert when next in line',
            'Get notified when you\'re next',
            widget.nextInLine,
            widget.onNextInLineChanged,
          ),
          SizedBox(height: 1.h),
          _buildNotificationOption(
            'Ready for consultation',
            'Get notified when it\'s your turn',
            widget.readyForConsultation,
            widget.onReadyForConsultationChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ],
    );
  }
}
