import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'services/supabase_service.dart';
import 'services/stripe_service.dart';
import 'services/auth_service.dart';
import 'presentation/splash_screen/splash_screen.dart';
import 'presentation/login_screen/login_screen.dart';
import 'presentation/dashboard/dashboard.dart';
import 'presentation/onboarding_flow/onboarding_flow.dart';
import 'presentation/new_job_screen/new_job_screen.dart';
import 'presentation/camera_interface/camera_interface.dart';
import 'presentation/photo_review_screen/photo_review_screen.dart';
import 'presentation/add_on_services/add_on_services.dart';
import 'presentation/order_summary/order_summary.dart';
import 'presentation/job_tracking_notifications/job_tracking_notifications.dart';
import 'presentation/tutorial_guides/tutorial_guides.dart';
import 'presentation/admin_panel/admin_panel.dart';
import 'presentation/2d_floorplan_creator/2d_floorplan_creator.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await SupabaseService.init();
  await StripeService.init();
  await AuthService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'HomeSnap Pro',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login-screen': (context) => const LoginScreen(),
            '/login': (context) => const LoginScreen(),
            '/dashboard': (context) => const Dashboard(),
            '/onboarding': (context) => const OnboardingFlow(),
            '/new-job': (context) => const NewJobScreen(),
            '/camera': (context) => const CameraInterface(),
            '/photo-review': (context) => const PhotoReviewScreen(),
            '/add-on-services': (context) => const AddOnServices(),
            '/order-summary': (context) => const OrderSummary(),
            '/job-tracking': (context) => const JobTrackingNotifications(),
            '/tutorials': (context) => const TutorialGuides(),
            '/admin': (context) => const AdminPanel(),
            '/floorplan-creator': (context) => const TwoDFloorplanCreator(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
          },
        );
      },
    );
  }
}
