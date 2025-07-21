import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterBottomSheetWidget({
    super.key,
    required this.currentFilters,
    required this.onApplyFilters,
  });

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  double _priceRange = 500.0;

  final List<String> _specializations = [
    'Cardiology',
    'Dermatology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Psychiatry',
    'General Medicine',
    'ENT',
  ];

  final List<String> _hospitals = [
    'Apollo Hospital',
    'Fortis Healthcare',
    'Max Healthcare',
    'AIIMS',
    'Manipal Hospital',
    'Narayana Health',
  ];

  final List<String> _consultationTypes = [
    'In-person',
    'Video Call',
    'Phone Call',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = (_filters['maxPrice'] as num?)?.toDouble() ?? 500.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
                  'Filter Doctors',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _filters.clear();
                      _priceRange = 500.0;
                    });
                  },
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Specialization',
                    _specializations,
                    'specializations',
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Hospital/Clinic',
                    _hospitals,
                    'hospitals',
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Consultation Type',
                    _consultationTypes,
                    'consultationTypes',
                  ),
                  SizedBox(height: 3.h),
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildAvailabilitySection(),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _filters['maxPrice'] = _priceRange;
                      widget.onApplyFilters(_filters);
                      Navigator.pop(context);
                    },
                    child: Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      String title, List<String> options, String filterKey) {
    final selectedOptions = (_filters[filterKey] as List<String>?) ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedOptions.remove(option);
                  } else {
                    selectedOptions.add(option);
                  }
                  _filters[filterKey] = selectedOptions;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consultation Fee Range',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Text(
              '₹0',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            Expanded(
              child: Slider(
                value: _priceRange,
                min: 0,
                max: 2000,
                divisions: 20,
                onChanged: (value) {
                  setState(() {
                    _priceRange = value;
                  });
                },
              ),
            ),
            Text(
              '₹2000+',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ],
        ),
        Center(
          child: Text(
            'Up to ₹${_priceRange.toInt()}',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    final availableOnly = _filters['availableOnly'] as bool? ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Availability',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Checkbox(
              value: availableOnly,
              onChanged: (value) {
                setState(() {
                  _filters['availableOnly'] = value ?? false;
                });
              },
            ),
            SizedBox(width: 2.w),
            Text(
              'Show only available doctors',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
