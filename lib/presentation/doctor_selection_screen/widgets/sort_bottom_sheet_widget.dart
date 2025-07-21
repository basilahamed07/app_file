import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortSelected;

  const SortBottomSheetWidget({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sortOptions = [
      {
        'key': 'availability',
        'title': 'Availability',
        'subtitle': 'Available doctors first'
      },
      {'key': 'rating', 'title': 'Rating', 'subtitle': 'Highest rated first'},
      {
        'key': 'experience',
        'title': 'Experience',
        'subtitle': 'Most experienced first'
      },
      {
        'key': 'fee_low',
        'title': 'Fee: Low to High',
        'subtitle': 'Lowest consultation fee first'
      },
      {
        'key': 'fee_high',
        'title': 'Fee: High to Low',
        'subtitle': 'Highest consultation fee first'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'Sort By',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortOptions.length,
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              final isSelected = currentSort == option['key'];

              return ListTile(
                onTap: () {
                  onSortSelected(option['key']!);
                  Navigator.pop(context);
                },
                leading: Radio<String>(
                  value: option['key']!,
                  groupValue: currentSort,
                  onChanged: (value) {
                    if (value != null) {
                      onSortSelected(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Text(
                  option['title']!,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  option['subtitle']!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
