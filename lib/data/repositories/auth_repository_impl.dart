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

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<void> sendOtp(String phoneNumber) async {
    return await _remoteDataSource.sendOtp(phoneNumber);
  }

  @override
  Future<AuthSession> verifyOtp(String phoneNumber, String code) async {
    final sessionModel = await _remoteDataSource.verifyOtp(phoneNumber, code);
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
