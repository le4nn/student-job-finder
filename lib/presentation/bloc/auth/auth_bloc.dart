import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import '../../../domain/usecases/get_current_session_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final AuthRepository _authRepository;
  final AppLogger _logger;

  AuthBloc(
    this._sendOtpUseCase,
    this._verifyOtpUseCase,
    this._getCurrentSessionUseCase,
    this._authRepository,
    this._logger,
  ) : super(const AuthInitial()) {
    on<AuthSendOtpRequested>(_onSendOtpRequested);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionCheckRequested>(_onSessionCheckRequested);
  }

  Future<void> _onSendOtpRequested(
    AuthSendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      await _sendOtpUseCase(event.phoneNumber);
      _logger.logAuth('OTP sent', phone: event.phoneNumber);
      emit(AuthOtpSent(event.phoneNumber));
    } catch (e) {
      _logger.logAuth('Send OTP failed', error: e.toString());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      final session = await _verifyOtpUseCase(event.phoneNumber, event.code);
      _logger.logAuth('Login success', phone: event.phoneNumber);
      emit(AuthAuthenticated(session));
    } catch (e) {
      _logger.logAuth('Login failed', error: e.toString());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      await _authRepository.logout();
      _logger.logAuth('Logout success');
      emit(const AuthUnauthenticated());
    } catch (e) {
      _logger.logAuth('Logout failed', error: e.toString());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSessionCheckRequested(
    AuthSessionCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      final session = await _getCurrentSessionUseCase();
      if (session != null) {
        _logger.logAuth('Session valid');
        emit(AuthAuthenticated(session));
      } else {
        _logger.logAuth('No session');
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      _logger.logAuth('Session check failed', error: e.toString());
      emit(const AuthUnauthenticated());
    }
  }
}
