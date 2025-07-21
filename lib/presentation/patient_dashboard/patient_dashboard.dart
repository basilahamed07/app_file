import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/active_token_card.dart';
import './widgets/medical_history_widget.dart';
import './widgets/navigation_breadcrumb_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_appointments_card.dart';
import './widgets/trust_elements_widget.dart';
import './widgets/upcoming_appointments_widget.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({Key? key}) : super(key: key);

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isRefreshing = false;

  // Mock data for active token
  final Map<String, dynamic>? activeToken = {
    "tokenNumber": "A-042",
    "doctorName": "Sarah Johnson",
    "department": "Cardiology",
    "queuePosition": 3,
    "estimatedWaitTime": "25 mins",
    "appointmentTime": "10:30 AM",
  };

  // Mock data for recent appointments
  final List<Map<String, dynamic>> recentAppointments = [
    {
      "id": 1,
      "doctorName": "Michael Chen",
      "department": "Orthopedics",
      "date": "15 Jul 2025",
      "time": "2:30 PM",
      "status": "Completed",
      "tokenNumber": "B-023",
    },
    {
      "id": 2,
      "doctorName": "Emily Rodriguez",
      "department": "Dermatology",
      "date": "12 Jul 2025",
      "time": "11:00 AM",
      "status": "Completed",
      "tokenNumber": "C-015",
    },
    {
      "id": 3,
      "doctorName": "David Kumar",
      "department": "General Medicine",
      "date": "08 Jul 2025",
      "time": "9:15 AM",
      "status": "Completed",
      "tokenNumber": "A-008",
    },
  ];

  // Mock data for upcoming appointments
  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      "id": 1,
      "doctorName": "Sarah Johnson",
      "department": "Cardiology",
      "date": "22 Jul 2025",
      "time": "10:30 AM",
      "tokenNumber": "A-042",
      "status": "Confirmed",
    },
    {
      "id": 2,
      "doctorName": "Robert Wilson",
      "department": "Neurology",
      "date": "25 Jul 2025",
      "time": "3:00 PM",
      "tokenNumber": "N-018",
      "status": "Confirmed",
    },
  ];

  // Mock data for medical history
  final List<Map<String, dynamic>> recentPrescriptions = [
    {
      "id": 1,
      "doctorName": "Sarah Johnson",
      "date": "20 Jul 2025",
      "medications": ["Lisinopril 10mg", "Metformin 500mg"],
      "downloadUrl": "https://example.com/prescription1.pdf",
    },
    {
      "id": 2,
      "doctorName": "Michael Chen",
      "date": "15 Jul 2025",
      "medications": ["Ibuprofen 400mg", "Calcium supplements"],
      "downloadUrl": "https://example.com/prescription2.pdf",
    },
  ];

  final List<Map<String, dynamic>> recentReports = [
    {
      "id": 1,
      "type": "Blood Test",
      "date": "18 Jul 2025",
      "doctorName": "Sarah Johnson",
      "downloadUrl": "https://example.com/report1.pdf",
    },
    {
      "id": 2,
      "type": "X-Ray",
      "date": "15 Jul 2025",
      "doctorName": "Michael Chen",
      "downloadUrl": "https://example.com/report2.pdf",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });
  }

  List<BreadcrumbItem> _getBreadcrumbs() {
    return [
      BreadcrumbItem(title: 'Home', onTap: () {}),
      BreadcrumbItem(title: 'Dashboard'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            NavigationBreadcrumbWidget(
              currentSection: _getTabTitle(_tabController.index),
              breadcrumbs: _getBreadcrumbs(),
            ),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildAppointmentsTab(),
                  _buildDoctorsTab(),
                  _buildProfileTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
          _tabController.index == 0 ? _buildFloatingActionButton() : null,
    );
  }

  String _getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Appointments';
      case 2:
        return 'Find Doctors';
      case 3:
        return 'Profile';
      default:
        return 'Dashboard';
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning,',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  'Priya Sharma',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIconWidget(
              iconName: 'notifications',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppTheme.lightTheme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        onTap: (index) => setState(() {}),
        tabs: [
          Tab(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _tabController.index == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            text: 'Dashboard',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'event',
              color: _tabController.index == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            text: 'Bookings',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'local_hospital',
              color: _tabController.index == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            text: 'Doctors',
          ),
          Tab(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _tabController.index == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 18,
            ),
            text: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),
            ActiveTokenCard(
              activeToken: activeToken,
              onTrackQueue: () {
                Navigator.pushNamed(context, '/queue-tracking-screen');
              },
            ),
            QuickActionsWidget(
              onBookToken: () {
                Navigator.pushNamed(context, '/token-booking-screen');
              },
              onEmergencyBooking: () {
                Navigator.pushNamed(context, '/token-booking-screen');
              },
              onFindDoctors: () {
                Navigator.pushNamed(context, '/doctor-selection-screen');
              },
            ),
            TrustElementsWidget(),
            RecentAppointmentsCard(
              recentAppointments: recentAppointments,
              onRebook: (appointment) {
                Navigator.pushNamed(context, '/token-booking-screen');
              },
            ),
            UpcomingAppointmentsWidget(
              upcomingAppointments: upcomingAppointments,
              onCancel: (appointment) {
                _showCancelDialog(appointment);
              },
              onReschedule: (appointment) {
                Navigator.pushNamed(context, '/token-booking-screen');
              },
              onViewDetails: (appointment) {
                _showAppointmentDetails(appointment);
              },
            ),
            MedicalHistoryWidget(
              recentPrescriptions: recentPrescriptions,
              recentReports: recentReports,
              onViewAllPrescriptions: () {
                // Navigate to prescriptions screen
              },
              onViewAllReports: () {
                // Navigate to reports screen
              },
            ),
            SizedBox(height: 10.h), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'event',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Your Bookings',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Manage appointments',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'local_hospital',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Find Specialists',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Browse verified doctors',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/doctor-selection-screen');
            },
            child: Text('Browse Doctors'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Your Profile',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Account settings',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, '/token-booking-screen');
      },
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        'Book Now',
        style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showCancelDialog(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Appointment'),
        content: Text(
          'Are you sure you want to cancel your appointment with Dr. ${(appointment["doctorName"] as String)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle cancellation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment cancelled successfully'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: Dr. ${(appointment["doctorName"] as String)}'),
            SizedBox(height: 1.h),
            Text('Department: ${(appointment["department"] as String)}'),
            SizedBox(height: 1.h),
            Text('Date: ${(appointment["date"] as String)}'),
            SizedBox(height: 1.h),
            Text('Time: ${(appointment["time"] as String)}'),
            if (appointment["tokenNumber"] != null) ...[
              SizedBox(height: 1.h),
              Text('Token: #${(appointment["tokenNumber"] as String)}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
