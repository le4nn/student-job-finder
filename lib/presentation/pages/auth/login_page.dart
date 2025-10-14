import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/network_checker.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../utils/controllers/masked_text_controller.dart';
import '../../../utils/extensions/string_extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final MaskedTextController _phoneController = MaskedTextController.phoneMask;
  final AppLogger _logger = getIt<AppLogger>();
  final NetworkChecker _networkChecker = getIt<NetworkChecker>();

  @override
  void initState() {
    super.initState();
    _logger.logNavigation('LoginPage');
    _checkNetworkOnStart();
  }

  void _checkNetworkOnStart() async {
    final isConnected = await _networkChecker.checkNetworkConnection();
    if (!isConnected) {
      _logger.logError('Network', 'No internet connection detected');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty || phone == '+7') {
      _logger.logUserInput('Phone', valid: false);
      _showError('Введите номер телефона');
      return;
    }
    
    final cleanPhone = phone.formattedPhone;
    if (!cleanPhone.isValidPhone) {
      _logger.logUserInput('Phone format', valid: false);
      _showError('Введите корректный номер телефона');
      return;
    }

    final isConnected = await _networkChecker.checkNetworkConnection();
    if (!isConnected) {
      _showError('Нет подключения к интернету');
      return;
    }

    _logger.logUserInput('Phone', valid: true);
    context.read<AuthBloc>().add(AuthSendOtpRequested(phone));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthOtpSent) {
                _logger.logNavigation('OtpVerificationPage');
                context.go(AppRoutes.otpVerification, extra: state.phoneNumber);
              } else if (state is AuthError) {
                _logger.logError('Login', state.message);
                _showError(state.message);
              }
            },
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // Logo and image
                Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[50],
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    size: 80,
                    color: Colors.blue,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Title
                const Text(
                  'JobFinder',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                const Text(
                  'Найди работу или стажировку мечты',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 48),
                
                // Phone number input
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Номер телефона',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: '+ 7 (777) 777 77 77',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Get code button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7CF6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Получить код',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Terms text
                const Text(
                  'Нажимая "Получить код", вы соглашаетесь с\nусловиями использования',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
