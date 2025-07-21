import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GoogleSignInWidget extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final bool isLoading;

  const GoogleSignInWidget({
    Key? key,
    required this.onGoogleSignIn,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline,
                thickness: 1.0,
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Google Sign-In Button
        SizedBox(
          height: 6.h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onGoogleSignIn,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
                width: 1.0,
              ),
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Google Logo
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'g_translate',
                      color: const Color(0xFF4285F4),
                      size: 4.w,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                Text(
                  'Continue with Google',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
