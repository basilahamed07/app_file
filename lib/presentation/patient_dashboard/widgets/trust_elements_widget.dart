import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrustElementsWidget extends StatelessWidget {
  const TrustElementsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trusted Healthcare',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSecurityBadges(),
          SizedBox(height: 2.h),
          _buildPatientTestimonials(),
        ],
      ),
    );
  }

  Widget _buildSecurityBadges() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified_user',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Secure & Certified',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 1.h,
            children: [
              _buildSecurityBadge('HIPAA Compliant', 'security'),
              _buildSecurityBadge('SSL Encrypted', 'lock'),
              _buildSecurityBadge('ISO 27001', 'verified'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityBadge(String title, String icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.secondaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.secondary,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientTestimonials() {
    final testimonials = [
      {
        'name': 'Dr. Sarah M.',
        'rating': 5,
        'text':
            'Streamlined appointment booking. Saves time for both patients and staff.',
        'role': 'Cardiologist'
      },
      {
        'name': 'Rajesh K.',
        'rating': 5,
        'text':
            'No more waiting in long queues. I can track my appointment from home.',
        'role': 'Patient'
      },
      {
        'name': 'Priya S.',
        'rating': 5,
        'text':
            'Very user-friendly interface. Easy booking and reliable notifications.',
        'role': 'Patient'
      },
    ];

    return Container(
      height: 20.h,
      child: PageView.builder(
        itemCount: testimonials.length,
        itemBuilder: (context, index) {
          final testimonial = testimonials[index];
          return Container(
            margin: EdgeInsets.only(right: 3.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...List.generate(
                      testimonial['rating'] as int,
                      (index) => CustomIconWidget(
                        iconName: 'star',
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                    Spacer(),
                    CustomIconWidget(
                      iconName: 'format_quote',
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Expanded(
                  child: Text(
                    testimonial['text'] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      '- ${testimonial['name']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      testimonial['role'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
