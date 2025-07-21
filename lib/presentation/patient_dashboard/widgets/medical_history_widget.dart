import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MedicalHistoryWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentPrescriptions;
  final List<Map<String, dynamic>> recentReports;
  final VoidCallback? onViewAllPrescriptions;
  final VoidCallback? onViewAllReports;

  const MedicalHistoryWidget({
    Key? key,
    required this.recentPrescriptions,
    required this.recentReports,
    this.onViewAllPrescriptions,
    this.onViewAllReports,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Medical History',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildHistoryCard(
                  title: 'Prescriptions',
                  count: recentPrescriptions.length,
                  icon: 'medication',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: onViewAllPrescriptions,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildHistoryCard(
                  title: 'Reports',
                  count: recentReports.length,
                  icon: 'assignment',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: onViewAllReports,
                ),
              ),
            ],
          ),
          if (recentPrescriptions.isNotEmpty) ...[
            SizedBox(height: 2.h),
            _buildRecentPrescriptions(),
          ],
        ],
      ),
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required int count,
    required String icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: icon,
                    color: color,
                    size: 20,
                  ),
                ),
                Spacer(),
                CustomIconWidget(
                  iconName: 'arrow_forward_ios',
                  color: color,
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              count.toString(),
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPrescriptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recent Prescriptions',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: onViewAllPrescriptions,
              child: Text(
                'View All',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              recentPrescriptions.length > 2 ? 2 : recentPrescriptions.length,
          itemBuilder: (context, index) {
            final prescription = recentPrescriptions[index];
            return _buildPrescriptionItem(prescription);
          },
        ),
      ],
    );
  }

  Widget _buildPrescriptionItem(Map<String, dynamic> prescription) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: 'medication',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${(prescription["doctorName"] as String)}',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  (prescription["date"] as String),
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'download',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
