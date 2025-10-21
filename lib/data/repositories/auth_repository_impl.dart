import 'package:injectable/injectable.dart';

import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/auth_session_model.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<AuthSession> registerPassword({
    String? email,
    String? phone,
    required String password,
    required String role,
  }) async {
    final sessionModel = await _remoteDataSource.registerPassword(
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<AuthSession> loginPassword({
    required String identifier,
    required String password,
  }) async {
    final sessionModel = await _remoteDataSource.loginPassword(
      identifier: identifier,
      password: password,
    );
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<void> requestPhoneCode(String phoneNumber, String role) async {
    return await _remoteDataSource.requestCode(phoneNumber, role);
  }

  @override
  Future<AuthSession> verifyPhoneCode(String phoneNumber, String code) async {
    final sessionModel = await _remoteDataSource.verifyCode(phoneNumber, code);
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<void> requestEmailCode(String email) async {
    return await _remoteDataSource.requestEmailCode(email);
  }

  @override
  Future<AuthSession> verifyEmailCode(String email, String code) async {
    final sessionModel = await _remoteDataSource.verifyEmailCode(email, code);
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<void> requestCode(String phoneNumber, String role) async {
    return await _remoteDataSource.requestCode(phoneNumber, role);
  }

  @override
  Future<AuthSession> verifyCode(String phoneNumber, String code) async {
    final sessionModel = await _remoteDataSource.verifyCode(phoneNumber, code);
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final sessionModel = await _remoteDataSource.register(
      name: name,
      email: email,
      password: password,
      role: role,
    );
    await _localDataSource.saveSession(sessionModel);
    return sessionModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearSession();
  }

  @override
  Future<AuthSession?> getCurrentSession() async {
    final sessionModel = await _localDataSource.getSession();
    return sessionModel?.toEntity();
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    final sessionModel = AuthSessionModel(
      token: session.token,
      user: session.user,
      expiresAt: session.expiresAt,
    );
    await _localDataSource.saveSession(sessionModel);
  }

  @override
  Future<void> clearSession() async {
    await _localDataSource.clearSession();
  }
}
