import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/network_checker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_padding.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/app_logo.dart';
import '../../widgets/auth/role_selector.dart';
import '../../widgets/common/primary_button.dart';
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
  String _selectedRole = 'student';

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
    context.read<AuthBloc>().add(AuthRequestCodeRequested(phone, _selectedRole));
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.snackbarError),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.lg),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthCodeSent) {
                _logger.logNavigation('OtpVerificationPage');
                context.go(AppRoutes.otpVerification, extra: {
                  'phoneNumber': state.phoneNumber,
                  'role': state.role,
                });
              } else if (state is AuthError) {
                _logger.logError('Login', state.message);
                _showError(state.message);
              }
            },
            child: Column(
              children: [
                const Spacer(flex: 2),

                const AppLogo(),

                SizedBox(height: AppPadding.xl),

                Text(
                  'JobFinder',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),

                SizedBox(height: AppPadding.sm),

                Text(
                  'Найди работу или стажировку мечты',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppPadding.xl),

                RoleSelector(
                  selectedRole: _selectedRole,
                  onRoleChanged: (role) => setState(() => _selectedRole = role),
                ),

                SizedBox(height: AppPadding.lg),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Номер телефона',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppPadding.sm),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+ 7 (777) 777 77 77',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.md),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppPadding.md,
                          vertical: AppPadding.md,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppPadding.xl),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return PrimaryButton(
                      text: 'Получить код',
                      onPressed: _sendOtp,
                      isLoading: isLoading,
                    );
                  },
                ),

                SizedBox(height: AppPadding.md),

                Text(
                  'Нажимая "Получить код", вы соглашаетесь с\nусловиями использования',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppPadding.md),

                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.divider)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                      child: Text(
                        'или',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.divider)),
                  ],
                ),

                SizedBox(height: AppPadding.md),

                OutlinedButton.icon(
                  onPressed: () => context.go('/login-password'),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Войти через пароль'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, AppSizes.buttonHeightLg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
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
