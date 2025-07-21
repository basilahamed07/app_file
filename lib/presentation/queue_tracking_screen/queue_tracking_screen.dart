import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/clinic_location_widget.dart';
import './widgets/doctor_info_widget.dart';
import './widgets/live_queue_widget.dart';
import './widgets/notification_settings_widget.dart';
import './widgets/queue_info_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/status_banner_widget.dart';
import './widgets/token_display_widget.dart';

class QueueTrackingScreen extends StatefulWidget {
  const QueueTrackingScreen({super.key});

  @override
  State<QueueTrackingScreen> createState() => _QueueTrackingScreenState();
}

class _QueueTrackingScreenState extends State<QueueTrackingScreen> {
  bool _isRefreshing = false;
  bool _fiveTokensAhead = true;
  bool _nextInLine = true;
  bool _readyForConsultation = true;

  // Mock data for queue tracking
  final Map<String, dynamic> _queueData = {
    "userToken": "A47",
    "queuePosition": 8,
    "progress": 0.65,
    "status": "Waiting",
    "statusMessage":
        "Please wait for your turn. You will be notified when ready.",
    "currentToken": "A39",
    "estimatedWaitTime": "25 mins",
    "patientsAhead": 8,
    "avgConsultationTime": "12 mins",
  };

  final Map<String, dynamic> _doctorData = {
    "name": "Dr. Priya Sharma",
    "photo":
        "https://images.pexels.com/photos/5327580/pexels-photo-5327580.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
    "status": "In Session",
    "room": "203",
    "specialization": "Cardiologist",
  };

  final List<Map<String, dynamic>> _liveQueue = [
    {
      "tokenNumber": "A39",
      "status": "In Progress",
      "time": "10:30 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A40",
      "status": "Waiting",
      "time": "10:45 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A41",
      "status": "Waiting",
      "time": "11:00 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A42",
      "status": "Waiting",
      "time": "11:15 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A43",
      "status": "Waiting",
      "time": "11:30 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A44",
      "status": "Waiting",
      "time": "11:45 AM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A45",
      "status": "Waiting",
      "time": "12:00 PM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A46",
      "status": "Waiting",
      "time": "12:15 PM",
      "isCurrentUser": false,
    },
    {
      "tokenNumber": "A47",
      "status": "Waiting",
      "time": "12:30 PM",
      "isCurrentUser": true,
    },
  ];

  final Map<String, dynamic> _clinicData = {
    "name": "HealthCare Plus Clinic",
    "address": "123 Medical Center, Anna Nagar, Chennai - 600040",
    "phone": "+91 98765 43210",
    "emergencyPhone": "+91 98765 43211",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 1.h),
                TokenDisplayWidget(
                  tokenNumber: _queueData['userToken'] as String,
                  progress: (_queueData['progress'] as double),
                  queuePosition: _queueData['queuePosition'] as int,
                ),
                StatusBannerWidget(
                  status: _queueData['status'] as String,
                  message: _queueData['statusMessage'] as String,
                ),
                QueueInfoWidget(
                  currentToken: _queueData['currentToken'] as String,
                  estimatedWaitTime: _queueData['estimatedWaitTime'] as String,
                  patientsAhead: _queueData['patientsAhead'] as int,
                  avgConsultationTime:
                      _queueData['avgConsultationTime'] as String,
                ),
                DoctorInfoWidget(
                  doctorData: _doctorData,
                ),
                LiveQueueWidget(
                  queueList: _liveQueue,
                ),
                QuickActionsWidget(
                  onCancelToken: _handleCancelToken,
                  onReschedule: _handleReschedule,
                  onCallClinic: _handleCallClinic,
                  onShareStatus: _handleShareStatus,
                ),
                NotificationSettingsWidget(
                  fiveTokensAhead: _fiveTokensAhead,
                  nextInLine: _nextInLine,
                  readyForConsultation: _readyForConsultation,
                  onFiveTokensAheadChanged: (value) {
                    setState(() {
                      _fiveTokensAhead = value;
                    });
                  },
                  onNextInLineChanged: (value) {
                    setState(() {
                      _nextInLine = value;
                    });
                  },
                  onReadyForConsultationChanged: (value) {
                    setState(() {
                      _readyForConsultation = value;
                    });
                  },
                ),
                ClinicLocationWidget(
                  clinicData: _clinicData,
                  onNavigate: _handleNavigateToClinic,
                  onEmergencyCall: _handleEmergencyCall,
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 1,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 6.w,
        ),
      ),
      title: Text(
        'Queue Tracking',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _handleRefresh,
          icon: _isRefreshing
              ? SizedBox(
                  width: 5.w,
                  height: 5.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
        ),
        IconButton(
          onPressed: _handleNotificationSettings,
          icon: CustomIconWidget(
            iconName: 'notifications',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Queue status updated',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleCancelToken() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Token',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your token A47? This action cannot be undone.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Keep Token',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/patient-dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Cancel Token',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReschedule() {
    Navigator.pushNamed(context, '/token-booking-screen');
  }

  void _handleCallClinic() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Call Clinic',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Would you like to call HealthCare Plus Clinic at ${_clinicData['phone']}?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Calling clinic...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text(
              'Call Now',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleShareStatus() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Token status shared successfully',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleNavigateToClinic() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening navigation to clinic...',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleEmergencyCall() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'warning',
              color: AppTheme.lightTheme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Emergency Call',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(
          'This will call the emergency line at ${_clinicData['emergencyPhone']}. Use only for medical emergencies.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Calling emergency line...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppTheme.lightTheme.colorScheme.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: Text(
              'Emergency Call',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: NotificationSettingsWidget(
                fiveTokensAhead: _fiveTokensAhead,
                nextInLine: _nextInLine,
                readyForConsultation: _readyForConsultation,
                onFiveTokensAheadChanged: (value) {
                  setState(() {
                    _fiveTokensAhead = value;
                  });
                },
                onNextInLineChanged: (value) {
                  setState(() {
                    _nextInLine = value;
                  });
                },
                onReadyForConsultationChanged: (value) {
                  setState(() {
                    _readyForConsultation = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
