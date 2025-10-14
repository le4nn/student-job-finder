import 'package:go_router/go_router.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/otp_verification_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String otpVerification = '/otp-verification';
  
  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final phoneNumber = state.extra as String;
          return OtpVerificationPage(phoneNumber: phoneNumber);
        },
      ),
    ],
  );
}
