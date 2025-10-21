import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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
                const SizedBox(height: 40),

                // Logo and image
                Container(
                  width: 150,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.blue[50],
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    size: 60,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'JobFinder',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Найди работу или стажировку мечты',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                const Text(
                  'Подтверждение',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Введите код из SMS на номер\n${widget.phoneNumber}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // OTP input section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Код подтверждения',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  _otpCode.length > index
                                      ? Colors.blue
                                      : Colors.grey[300]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[50],
                          ),
                          child: Center(
                            child: Text(
                              _otpCode.length > index ? _otpCode[index] : '',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

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

                const SizedBox(height: 24),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            isLoading || _otpCode.length != 6
                                ? null
                                : _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B7CF6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  'Продолжить',
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

                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text(
                    'Изменить номер телефона',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 8),

                // Resend code
                TextButton(
                  onPressed: _canResendCode ? _resendCode : null,
                  child: Text(
                    _canResendCode
                        ? 'Отправить код повторно'
                        : 'Отправить код повторно ($_resendTimerс)',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          _canResendCode
                              ? const Color(0xFF8B7CF6)
                              : Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
