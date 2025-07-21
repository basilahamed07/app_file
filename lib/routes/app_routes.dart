import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/patient_dashboard/patient_dashboard.dart';
import '../presentation/doctor_selection_screen/doctor_selection_screen.dart';
import '../presentation/queue_tracking_screen/queue_tracking_screen.dart';
import '../presentation/token_booking_screen/token_booking_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String loginScreen = '/login-screen';
  static const String patientDashboard = '/patient-dashboard';
  static const String doctorSelectionScreen = '/doctor-selection-screen';
  static const String queueTrackingScreen = '/queue-tracking-screen';
  static const String tokenBookingScreen = '/token-booking-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    loginScreen: (context) => const LoginScreen(),
    patientDashboard: (context) => const PatientDashboard(),
    doctorSelectionScreen: (context) => const DoctorSelectionScreen(),
    queueTrackingScreen: (context) => const QueueTrackingScreen(),
    tokenBookingScreen: (context) => const TokenBookingScreen(),
    // TODO: Add your other routes here
  };
}
