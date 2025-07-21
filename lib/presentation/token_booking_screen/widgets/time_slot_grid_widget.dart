import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TimeSlotGridWidget extends StatelessWidget {
  final List<Map<String, dynamic>> timeSlots;
  final String? selectedTimeSlot;
  final Function(String) onTimeSlotSelected;

  const TimeSlotGridWidget({
    Key? key,
    required this.timeSlots,
    required this.selectedTimeSlot,
    required this.onTimeSlotSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time Slots',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2.w,
            mainAxisSpacing: 1.h,
            childAspectRatio: 2.5,
          ),
          itemCount: timeSlots.length,
          itemBuilder: (context, index) {
            final slot = timeSlots[index];
            final time = slot['time'] as String;
            final isAvailable = slot['isAvailable'] as bool;
            final isSelected = selectedTimeSlot == time;

            return GestureDetector(
              onTap: isAvailable ? () => onTimeSlotSelected(time) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : isAvailable
                          ? AppTheme.lightTheme.colorScheme.surface
                          : AppTheme.lightTheme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isAvailable
                            ? AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3)
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.onPrimary
                          : isAvailable
                              ? AppTheme.lightTheme.colorScheme.onSurface
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
