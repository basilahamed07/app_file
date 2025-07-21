import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;
  final List<Map<String, dynamic>> paymentMethods;

  const PaymentMethodWidget({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.paymentMethods,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paymentMethods.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final method = paymentMethods[index];
            final isSelected = selectedMethod == method['id'];

            return GestureDetector(
              onTap: () => onMethodChanged(method['id'] as String),
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primaryContainer
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: method['icon'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CustomImageWidget(
                                imageUrl: method['icon'] as String,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.contain,
                              ),
                            )
                          : CustomIconWidget(
                              iconName:
                                  _getIconForType(method['type'] as String),
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 24,
                            ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method['name'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: isSelected
                                  ? AppTheme
                                      .lightTheme.colorScheme.onPrimaryContainer
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (method['details'] != null) ...[
                            SizedBox(height: 0.5.h),
                            Text(
                              method['details'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme
                                        .onPrimaryContainer
                                        .withValues(alpha: 0.8)
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isSelected)
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => _showAddPaymentMethod(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Add New Payment Method',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getIconForType(String type) {
    switch (type) {
      case 'card':
        return 'credit_card';
      case 'upi':
        return 'account_balance_wallet';
      case 'wallet':
        return 'wallet';
      default:
        return 'payment';
    }
  }

  void _showAddPaymentMethod(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Add Payment Method',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              _buildPaymentOption('Credit/Debit Card', 'credit_card'),
              SizedBox(height: 1.h),
              _buildPaymentOption('UPI', 'account_balance_wallet'),
              SizedBox(height: 1.h),
              _buildPaymentOption('Net Banking', 'account_balance'),
              SizedBox(height: 1.h),
              _buildPaymentOption('Wallet', 'wallet'),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String title, String iconName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          SizedBox(width: 3.w),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          CustomIconWidget(
            iconName: 'arrow_forward_ios',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}
