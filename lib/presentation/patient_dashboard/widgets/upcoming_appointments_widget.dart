import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UpcomingAppointmentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> upcomingAppointments;
  final Function(Map<String, dynamic>)? onCancel;
  final Function(Map<String, dynamic>)? onReschedule;
  final Function(Map<String, dynamic>)? onViewDetails;

  const UpcomingAppointmentsWidget({
    Key? key,
    required this.upcomingAppointments,
    this.onCancel,
    this.onReschedule,
    this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (upcomingAppointments.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upcoming Appointments',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: upcomingAppointments.length,
            itemBuilder: (context, index) {
              final appointment = upcomingAppointments[index];
              return _buildAppointmentCard(appointment, context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> appointment, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dr. ${(appointment["doctorName"] as String)}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      (appointment["department"] as String),
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'reschedule':
                      onReschedule?.call(appointment);
                      break;
                    case 'cancel':
                      onCancel?.call(appointment);
                      break;
                    case 'details':
                      onViewDetails?.call(appointment);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'reschedule',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('Reschedule'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'cancel',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('Cancel'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'details',
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('View Details'),
                      ],
                    ),
                  ),
                ],
                child: CustomIconWidget(
                  iconName: 'more_vert',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  (appointment["date"] as String),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                CustomIconWidget(
                  iconName: 'access_time',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 18,
                ),
                SizedBox(width: 2.w),
                Text(
                  (appointment["time"] as String),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (appointment["tokenNumber"] != null) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Token: ',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '#${(appointment["tokenNumber"] as String)}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Upcoming Appointments',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Book your next appointment to see it here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to booking screen
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }
}
