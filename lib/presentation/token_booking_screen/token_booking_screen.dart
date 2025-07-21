import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/booking_type_selector_widget.dart';
import './widgets/consultation_type_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/doctor_card_widget.dart';
import './widgets/emergency_toggle_widget.dart';
import './widgets/payment_method_widget.dart';
import './widgets/queue_status_widget.dart';
import './widgets/reason_input_widget.dart';
import './widgets/time_slot_grid_widget.dart';

class TokenBookingScreen extends StatefulWidget {
  const TokenBookingScreen({Key? key}) : super(key: key);

  @override
  State<TokenBookingScreen> createState() => _TokenBookingScreenState();
}

class _TokenBookingScreenState extends State<TokenBookingScreen> {
  String selectedBookingType = 'instant';
  DateTime selectedDate = DateTime.now();
  String? selectedTimeSlot;
  String selectedConsultationType = 'in-person';
  bool isEmergency = false;
  String selectedPaymentMethod = 'card_1';
  bool isLoading = false;

  final TextEditingController reasonController = TextEditingController();

  // Mock data
  final Map<String, dynamic> selectedDoctor = {
    'id': 1,
    'name': 'Dr. Priya Sharma',
    'specialization': 'General Physician',
    'image':
        'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face',
    'rating': 4.8,
    'reviews': 324,
    'isAvailable': true,
  };

  final Map<String, dynamic> queueData = {
    'nextToken': 'A15',
    'peopleAhead': 8,
    'estimatedWaitTime': 45,
  };

  final List<Map<String, dynamic>> availableDates = [
    {'date': DateTime.now(), 'isAvailable': true},
    {'date': DateTime.now().add(const Duration(days: 1)), 'isAvailable': true},
    {'date': DateTime.now().add(const Duration(days: 2)), 'isAvailable': false},
    {'date': DateTime.now().add(const Duration(days: 3)), 'isAvailable': true},
    {'date': DateTime.now().add(const Duration(days: 4)), 'isAvailable': true},
    {'date': DateTime.now().add(const Duration(days: 5)), 'isAvailable': false},
    {'date': DateTime.now().add(const Duration(days: 6)), 'isAvailable': true},
  ];

  final List<Map<String, dynamic>> timeSlots = [
    {'time': '09:00 AM', 'isAvailable': true},
    {'time': '09:30 AM', 'isAvailable': false},
    {'time': '10:00 AM', 'isAvailable': true},
    {'time': '10:30 AM', 'isAvailable': true},
    {'time': '11:00 AM', 'isAvailable': false},
    {'time': '11:30 AM', 'isAvailable': true},
    {'time': '02:00 PM', 'isAvailable': true},
    {'time': '02:30 PM', 'isAvailable': true},
    {'time': '03:00 PM', 'isAvailable': false},
    {'time': '03:30 PM', 'isAvailable': true},
    {'time': '04:00 PM', 'isAvailable': true},
    {'time': '04:30 PM', 'isAvailable': true},
  ];

  final Map<String, String> consultationPricing = {
    'in-person': '₹500',
    'video-call': '₹400',
  };

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'card_1',
      'name': 'HDFC Credit Card',
      'details': '**** **** **** 1234',
      'type': 'card',
      'icon': null,
    },
    {
      'id': 'upi_1',
      'name': 'Google Pay',
      'details': 'priya.sharma@okaxis',
      'type': 'upi',
      'icon': null,
    },
    {
      'id': 'wallet_1',
      'name': 'Paytm Wallet',
      'details': 'Balance: ₹1,250',
      'type': 'wallet',
      'icon': null,
    },
  ];

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  bool get canBookAppointment {
    if (selectedBookingType == 'instant') {
      return reasonController.text.isNotEmpty &&
          selectedPaymentMethod.isNotEmpty;
    } else {
      return selectedTimeSlot != null &&
          reasonController.text.isNotEmpty &&
          selectedPaymentMethod.isNotEmpty;
    }
  }

  double get totalAmount {
    double baseAmount = selectedConsultationType == 'in-person' ? 500.0 : 400.0;
    if (isEmergency) {
      baseAmount += 200.0;
    }
    return baseAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Book Token',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor Card
                    DoctorCardWidget(doctor: selectedDoctor),
                    SizedBox(height: 3.h),

                    // Booking Type Selector
                    BookingTypeSelectorWidget(
                      selectedType: selectedBookingType,
                      onTypeChanged: (type) {
                        setState(() {
                          selectedBookingType = type;
                          if (type == 'instant') {
                            selectedTimeSlot = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Queue Status (for instant booking)
                    if (selectedBookingType == 'instant') ...[
                      QueueStatusWidget(queueData: queueData),
                      SizedBox(height: 3.h),
                    ],

                    // Date Picker (for scheduled booking)
                    if (selectedBookingType == 'scheduled') ...[
                      DatePickerWidget(
                        selectedDate: selectedDate,
                        onDateSelected: (date) {
                          setState(() {
                            selectedDate = date;
                            selectedTimeSlot =
                                null; // Reset time slot when date changes
                          });
                        },
                        availableDates: availableDates,
                      ),
                      SizedBox(height: 3.h),

                      // Time Slot Grid
                      TimeSlotGridWidget(
                        timeSlots: timeSlots,
                        selectedTimeSlot: selectedTimeSlot,
                        onTimeSlotSelected: (timeSlot) {
                          setState(() {
                            selectedTimeSlot = timeSlot;
                          });
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],

                    // Consultation Type
                    ConsultationTypeWidget(
                      selectedType: selectedConsultationType,
                      onTypeChanged: (type) {
                        setState(() {
                          selectedConsultationType = type;
                        });
                      },
                      pricing: consultationPricing,
                    ),
                    SizedBox(height: 3.h),

                    // Reason for Visit
                    ReasonInputWidget(
                      controller: reasonController,
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Emergency Toggle
                    EmergencyToggleWidget(
                      isEmergency: isEmergency,
                      onToggleChanged: (value) {
                        setState(() {
                          isEmergency = value;
                        });
                      },
                    ),
                    SizedBox(height: 3.h),

                    // Payment Method
                    PaymentMethodWidget(
                      selectedMethod: selectedPaymentMethod,
                      onMethodChanged: (method) {
                        setState(() {
                          selectedPaymentMethod = method;
                        });
                      },
                      paymentMethods: paymentMethods,
                    ),
                    SizedBox(height: 3.h),

                    // Total Amount
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color:
                            AppTheme.lightTheme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'receipt',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Amount',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleSmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSecondaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isEmergency) ...[
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Includes ₹200 emergency charges',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSecondaryContainer
                                          .withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            '₹${totalAmount.toStringAsFixed(0)}',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSecondaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed:
                  canBookAppointment && !isLoading ? _confirmBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canBookAppointment
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.surfaceContainer,
                foregroundColor: canBookAppointment
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                elevation: canBookAppointment ? 2 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: canBookAppointment
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Confirm Booking - ₹${totalAmount.toStringAsFixed(0)}',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: canBookAppointment
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmBooking() async {
    setState(() {
      isLoading = true;
    });

    // Simulate booking process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });

    // Show success dialog
    _showBookingSuccess();
  }

  void _showBookingSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  size: 40,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Booking Confirmed!',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                selectedBookingType == 'instant'
                    ? 'Your token number is A16'
                    : 'Your appointment is scheduled for ${selectedTimeSlot ?? ''} on ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 60,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'QR Code',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/queue-tracking-screen');
              },
              child: Text(
                'Track Queue',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/patient-dashboard');
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}
