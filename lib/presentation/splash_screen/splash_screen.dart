import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/app_title_widget.dart';
import './widgets/background_gradient_widget.dart';
import './widgets/loading_indicator_widget.dart';
import './widgets/retry_button_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _fadeAnimation;

  bool _isLoading = true;
  bool _showRetry = false;
  String _loadingText = 'Initializing healthcare services...';

  // Mock user authentication states
  final Map<String, dynamic> _mockUserData = {
    'isAuthenticated': true,
    'userType': 'patient', // patient, doctor, admin
    'userId': 'user_12345',
    'preferences': {
      'theme': 'light',
      'language': 'en',
      'notifications': true,
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: Curves.easeIn,
    ));

    _mainAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Set system UI overlay style for medical branding
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: AppTheme.lightTheme.colorScheme.primary,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );

      // Simulate initialization tasks
      await _performInitializationTasks();

      // Navigate based on authentication status
      if (mounted) {
        await _navigateToNextScreen();
      }
    } catch (e) {
      if (mounted) {
        _handleInitializationError();
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    final List<Future<void>> initTasks = [
      _checkAuthenticationToken(),
      _loadUserPreferences(),
      _fetchClinicConfigurations(),
      _prepareCachedMedicalData(),
    ];

    for (int i = 0; i < initTasks.length; i++) {
      await initTasks[i];
      if (mounted) {
        setState(() {
          _loadingText = _getLoadingMessage(i + 1);
        });
      }
      // Small delay for visual feedback
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _checkAuthenticationToken() async {
    // Simulate token validation
    await Future.delayed(const Duration(milliseconds: 800));
    // Mock authentication check
    _mockUserData['tokenValid'] = DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> _loadUserPreferences() async {
    // Simulate loading user preferences
    await Future.delayed(const Duration(milliseconds: 600));
    // Mock preferences loading
    _mockUserData['preferencesLoaded'] = true;
  }

  Future<void> _fetchClinicConfigurations() async {
    // Simulate fetching clinic data
    await Future.delayed(const Duration(milliseconds: 700));
    // Mock clinic configurations
    _mockUserData['clinicConfig'] = {
      'availableClinics': ['City Hospital', 'Metro Clinic', 'Health Center'],
      'operatingHours': '08:00 - 20:00',
      'emergencyContact': '+91-9876543210',
    };
  }

  Future<void> _prepareCachedMedicalData() async {
    // Simulate preparing cached data
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock cached data preparation
    _mockUserData['cachedDataReady'] = true;
  }

  String _getLoadingMessage(int step) {
    switch (step) {
      case 1:
        return 'Verifying authentication...';
      case 2:
        return 'Loading user preferences...';
      case 3:
        return 'Fetching clinic configurations...';
      case 4:
        return 'Preparing medical data...';
      default:
        return 'Initializing healthcare services...';
    }
  }

  Future<void> _navigateToNextScreen() async {
    // Add smooth transition delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    // Navigation logic based on user state
    final bool isAuthenticated = _mockUserData['isAuthenticated'] ?? false;
    final String userType = _mockUserData['userType'] ?? 'patient';

    String nextRoute;

    if (isAuthenticated) {
      // Navigate to role-specific dashboard
      switch (userType) {
        case 'patient':
          nextRoute = '/patient-dashboard';
          break;
        case 'doctor':
          nextRoute = '/doctor-selection-screen';
          break;
        case 'admin':
          nextRoute = '/patient-dashboard'; // Fallback to patient dashboard
          break;
        default:
          nextRoute = '/patient-dashboard';
      }
    } else {
      // Navigate to login for non-authenticated users
      nextRoute = '/login-screen';
    }

    // Perform navigation with fade transition
    Navigator.pushReplacementNamed(context, nextRoute);
  }

  void _handleInitializationError() {
    setState(() {
      _isLoading = false;
      _showRetry = true;
    });

    // Auto-retry after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showRetry) {
        _retryInitialization();
      }
    });
  }

  void _retryInitialization() {
    setState(() {
      _isLoading = true;
      _showRetry = false;
      _loadingText = 'Retrying initialization...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient
            const BackgroundGradientWidget(),

            // Main content
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer for top positioning
                    SizedBox(height: 15.h),

                    // Animated logo
                    const AnimatedLogoWidget(),

                    SizedBox(height: 4.h),

                    // App title and tagline
                    const AppTitleWidget(),

                    // Flexible spacer
                    const Spacer(),

                    // Loading indicator or retry button
                    _isLoading && !_showRetry
                        ? LoadingIndicatorWidget(loadingText: _loadingText)
                        : _showRetry
                            ? RetryButtonWidget(onRetry: _retryInitialization)
                            : const SizedBox.shrink(),

                    SizedBox(height: 8.h),

                    // Version info
                    Text(
                      'Version 1.0.0',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10.sp,
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
