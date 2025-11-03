import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../../core/routes/app_routes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/constants/app_padding.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_values.dart';
import '../../../bloc/common/auth/auth_bloc.dart';
import '../../../bloc/common/auth/auth_event.dart';
import '../../../bloc/common/auth/auth_state.dart';
import '../../../widgets/common/auth/app_logo.dart';
import '../../../widgets/common/auth/otp_input_boxes.dart';
import '../../../widgets/common/primary_button.dart';

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
  int _resendTimer = AppDurations.resendTimerSeconds;
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
    if (cleanValue.length <= AppValues.otpLength) {
      setState(() {
        _otpCode = cleanValue;
      });
      _otpController.text = cleanValue;
      _otpController.selection = TextSelection.fromPosition(
        TextPosition(offset: cleanValue.length),
      );

      if (cleanValue.length == AppValues.otpLength) {
        _verifyCode();
      }
    }
  }

  void _verifyCode() {
    if (_otpCode.length != AppValues.otpLength) {
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
      _resendTimer = AppDurations.resendTimerSeconds;
    });

    _timer?.cancel();
    _timer = Timer.periodic(AppDurations.timerTick, (timer) {
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
      SnackBar(content: Text(message), backgroundColor: AppColors.snackbarError),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.snackbarSuccess),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: ResponsiveBuilder(
        builder: (context, sizingInfo) {
          return SafeArea(
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthAuthenticated) {
                  _showSuccess('Код подтвержден успешно!');
                  context.go(AppRoutes.employerHome);
                } else if (state is AuthError) {
                  _showError(state.message);
                } else if (state is AuthCodeSent) {
                  _showSuccess('Код отправлен повторно');
                }
              },
              child: ScreenTypeLayout.builder(
                mobile: (context) => _buildMobileLayout(colorScheme, sizingInfo),
                tablet: (context) => _buildTabletLayout(colorScheme, sizingInfo),
                desktop: (context) => _buildDesktopLayout(colorScheme, sizingInfo),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMobileLayout(ColorScheme colorScheme, SizingInformation sizingInfo) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppPadding.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppPadding.xxl),
          Center(child: AppLogo(size: AppSizes.logoMedium)),
          SizedBox(height: AppPadding.xl),
          Text(
            'JobFinder',
            style: AppTextStyles.headlineMedium.copyWith(
              color: colorScheme.onBackground,
            ),
            textAlign: TextAlign.center,
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
            textAlign: TextAlign.center,
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
                opacity: AppSizes.opacityHidden,
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: AppValues.maxOtpFieldLength,
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
                onPressed: _otpCode.length == AppValues.otpLength ? _verifyCode : null,
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
        ],
      ),
    );
  }

  Widget _buildTabletLayout(ColorScheme colorScheme, SizingInformation sizingInfo) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: EdgeInsets.all(AppPadding.xl),
        child: _buildMobileLayout(colorScheme, sizingInfo),
      ),
    );
  }

  Widget _buildDesktopLayout(ColorScheme colorScheme, SizingInformation sizingInfo) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: EdgeInsets.all(AppPadding.xl * 2),
        child: _buildMobileLayout(colorScheme, sizingInfo),
      ),
    );
  }
}
