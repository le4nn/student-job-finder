import 'package:go_router/go_router.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/login_password_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/auth/otp_verification_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String loginPassword = '/login-password';
  static const String register = '/register';
  static const String otpVerification = '/otp-verification';
  
  static final GoRouter router = GoRouter(
    initialLocation: loginPassword,
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: loginPassword,
        builder: (context, state) => const LoginPasswordPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: otpVerification,
        builder: (context, state) {
          final params = state.extra as Map<String, dynamic>;
          final phoneNumber = params['phoneNumber'] as String;
          final role = params['role'] as String;
          return OtpVerificationPage(
            phoneNumber: phoneNumber,
            role: role,
          );
        },
      ),
    ],
  );
}
