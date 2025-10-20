import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/app_logger.dart';
import '../../../domain/usecases/request_code_usecase.dart';
import '../../../domain/usecases/verify_code_usecase.dart';
import '../../../domain/usecases/get_current_session_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RequestCodeUseCase _requestCodeUseCase;
  final VerifyCodeUseCase _verifyCodeUseCase;
  final GetCurrentSessionUseCase _getCurrentSessionUseCase;
  final AuthRepository _authRepository;
  final AppLogger _logger;

  AuthBloc(
    this._requestCodeUseCase,
    this._verifyCodeUseCase,
    this._getCurrentSessionUseCase,
    this._authRepository,
    this._logger,
  ) : super(const AuthInitial()) {
    on<AuthRequestCodeRequested>(_onRequestCodeRequested);
    on<AuthVerifyCodeRequested>(_onVerifyCodeRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionCheckRequested>(_onSessionCheckRequested);
  }

  Future<void> _onRequestCodeRequested(
    AuthRequestCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      await _requestCodeUseCase(event.phoneNumber);
      _logger.logAuth('Code sent', phone: event.phoneNumber);
      emit(AuthCodeSent(event.phoneNumber));
    } catch (e) {
      _logger.logAuth('Request code failed', error: e.toString());
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onVerifyCodeRequested(
    AuthVerifyCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    try {
      final session = await _verifyCodeUseCase(event.phoneNumber, event.code);
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
