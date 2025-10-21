import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_padding.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_colors.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../widgets/auth/app_logo.dart';
import '../../widgets/auth/otp_input_boxes.dart';
import '../../widgets/common/primary_button.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String role;

  const OtpVerificationPage({super.key, required this.phoneNumber, required this.role});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpController = TextEditingController();
  String _otpCode = '';
  bool _canResendCode = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanValue.length <= 6) {
      setState(() {
        _otpCode = cleanValue;
      });
      _otpController.text = cleanValue;
      _otpController.selection = TextSelection.fromPosition(
        TextPosition(offset: cleanValue.length),
      );

      if (cleanValue.length == 6) {
        _verifyCode();
      }
    }
  }

  void _verifyCode() {
    if (_otpCode.length != 6) {
      _showError('Введите 6-значный код');
      return;
    }

    context.read<AuthBloc>().add(
      AuthVerifyCodeRequested(widget.phoneNumber, _otpCode),
    );
  }

  void _resendCode() {
    if (!_canResendCode) return;

    context.read<AuthBloc>().add(AuthRequestCodeRequested(widget.phoneNumber, widget.role));
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _canResendCode = false;
      _resendTimer = 60;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResendCode = true;
        });
        timer.cancel();
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppPadding.lg),
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                _showSuccess('Код подтвержден успешно!');
                // TODO: Navigate to home page
              } else if (state is AuthError) {
                _showError(state.message);
              } else if (state is AuthCodeSent) {
                _showSuccess('Код отправлен повторно');
              }
            },
            child: Column(
              children: [
                SizedBox(height: AppPadding.xxl),

                AppLogo(size: 120.w),

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

                Text(
                  'Подтверждение',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: colorScheme.onBackground,
                  ),
                ),

                SizedBox(height: AppPadding.sm),

                Text(
                  'Введите код из SMS на номер\n${widget.phoneNumber}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppPadding.lg),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Код подтверждения',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: AppPadding.sm),

                    OtpInputBoxes(otpCode: _otpCode),

                    Opacity(
                      opacity: 0.0,
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        autofocus: true,
                        onChanged: _onOtpChanged,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppPadding.lg),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return PrimaryButton(
                      text: 'Продолжить',
                      onPressed: _otpCode.length == 6 ? _verifyCode : null,
                      isLoading: isLoading,
                    );
                  },
                ),

                SizedBox(height: AppPadding.md),

                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Изменить номер телефона',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                SizedBox(height: AppPadding.sm),

                TextButton(
                  onPressed: _canResendCode ? _resendCode : null,
                  child: Text(
                    _canResendCode
                        ? 'Отправить код повторно'
                        : 'Отправить код повторно ($_resendTimerс)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _canResendCode
                          ? colorScheme.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),

                SizedBox(height: AppPadding.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
