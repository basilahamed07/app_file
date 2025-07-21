import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReasonInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const ReasonInputWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<ReasonInputWidget> createState() => _ReasonInputWidgetState();
}

class _ReasonInputWidgetState extends State<ReasonInputWidget> {
  final List<String> suggestions = [
    'Fever and cold',
    'Headache',
    'Stomach pain',
    'Back pain',
    'Skin rash',
    'Chest pain',
    'Cough',
    'Dizziness',
    'Joint pain',
    'Regular checkup',
  ];

  List<String> filteredSuggestions = [];
  bool showSuggestions = false;

  @override
  void initState() {
    super.initState();
    filteredSuggestions = suggestions;
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSuggestions = suggestions;
        showSuggestions = false;
      } else {
        filteredSuggestions = suggestions
            .where((suggestion) =>
                suggestion.toLowerCase().contains(query.toLowerCase()))
            .toList();
        showSuggestions = filteredSuggestions.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Visit',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: widget.controller,
          onChanged: (value) {
            widget.onChanged(value);
            _filterSuggestions(value);
          },
          onTap: () {
            setState(() {
              showSuggestions = widget.controller.text.isNotEmpty;
            });
          },
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Describe your symptoms or reason for consultation...',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    // Voice input functionality would be implemented here
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Voice input feature coming soon'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: CustomIconWidget(
                    iconName: 'mic',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
                SizedBox(width: 1.w),
              ],
            ),
          ),
        ),
        if (showSuggestions && filteredSuggestions.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredSuggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final suggestion = filteredSuggestions[index];
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'medical_services',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  title: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    widget.controller.text = suggestion;
                    widget.onChanged(suggestion);
                    setState(() {
                      showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
