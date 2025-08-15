import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/new_job_screen/new_job_screen.dart';
import '../presentation/camera_interface/camera_interface.dart';
import '../presentation/photo_review_screen/photo_review_screen.dart';
import '../presentation/add_on_services/add_on_services.dart';
import '../presentation/order_summary/order_summary.dart';
import '../presentation/job_tracking_notifications/job_tracking_notifications.dart';
import '../presentation/tutorial_guides/tutorial_guides.dart';
import '../presentation/admin_panel/admin_panel.dart';

class AppRoutes {
  static const String splashScreen = '/splash-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String loginScreen = '/login-screen';
  static const String dashboard = '/dashboard';
  static const String initial = '/dashboard';
  static const String newJobScreen = '/new-job-screen';
  static const String cameraInterface = '/camera-interface';
  static const String photoReviewScreen = '/photo-review-screen';
  static const String addOnServices = '/add-on-services';
  static const String orderSummary = '/order-summary';
  static const String jobTrackingNotifications = '/job-tracking-notifications';
  static const String tutorialGuides = '/tutorial-guides';
  static const String adminPanel = '/admin-panel';

  static Map<String, WidgetBuilder> routes = {
    splashScreen: (context) => const SplashScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    loginScreen: (context) => const LoginScreen(),
    dashboard: (context) => const Dashboard(),
    newJobScreen: (context) => const NewJobScreen(),
    cameraInterface: (context) => const CameraInterface(),
    photoReviewScreen: (context) => const PhotoReviewScreen(),
    addOnServices: (context) => const AddOnServices(),
    orderSummary: (context) => const OrderSummary(),
    jobTrackingNotifications: (context) => const JobTrackingNotifications(),
    tutorialGuides: (context) => const TutorialGuides(),
    adminPanel: (context) => const AdminPanel(),
  };
}
