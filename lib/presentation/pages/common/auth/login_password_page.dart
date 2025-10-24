import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/sg_snackbar.dart';
import '../../../../core/utils/exception_handler.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../bloc/common/auth/auth_bloc.dart';
import '../../../bloc/common/auth/auth_event.dart';
import '../../../bloc/common/auth/auth_state.dart';
import '../../../widgets/common/auth/app_logo.dart';
import '../../../widgets/common/primary_button.dart';

class LoginPasswordPage extends StatefulWidget {
  const LoginPasswordPage({super.key});

  @override
  State<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final identifier = _identifierController.text.trim();
    final password = _passwordController.text;

    if (identifier.isEmpty) {
      _showError('Введите email или телефон');
      return;
    }

    if (password.isEmpty) {
      _showError('Введите пароль');
      return;
    }

    context.read<AuthBloc>().add(AuthLoginPasswordRequested(
      identifier: identifier,
      password: password,
    ));
  }

  void _showError(String message) {
    snackBarBuilder(SnackBarOptions(
      type: SnackBarType.error,
      exception: ExceptionHandler(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.lg),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                context.go(AppRoutes.employerHome);
              } else if (state is AuthError) {
                _showError(state.message);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppPadding.xxl * 2),

                const Center(child: AppLogo()),

                SizedBox(height: AppPadding.xl),

                Text(
                  'Вход',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppPadding.sm),

                Text(
                  'Войдите с email или телефоном',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppPadding.xxl),

                TextField(
                  controller: _identifierController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email или телефон',
                    hintText: 'your@email.com или +7...',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
                ),

                SizedBox(height: AppPadding.md),

                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    hintText: 'Введите пароль',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
                ),

                SizedBox(height: AppPadding.xl),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return PrimaryButton(
                      text: 'Войти',
                      onPressed: _login,
                      isLoading: isLoading,
                    );
                  },
                ),

                SizedBox(height: AppPadding.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Нет аккаунта? ',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/register'),
                      child: Text(
                        'Регистрация',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.phone_android),
                  label: const Text('Войти через код'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, AppSizes.buttonHeightLg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
