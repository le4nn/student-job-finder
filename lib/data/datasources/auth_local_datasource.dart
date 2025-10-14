import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/auth_session_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthSessionModel?> getSession();
  Future<void> saveSession(AuthSessionModel session);
  Future<void> clearSession();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _sessionKey = 'auth_session';
  final SharedPreferences _prefs;

  AuthLocalDataSourceImpl(this._prefs);

  @override
  Future<AuthSessionModel?> getSession() async {
    try {
      final sessionJson = _prefs.getString(_sessionKey);
      if (sessionJson != null) {
        final sessionMap = jsonDecode(sessionJson) as Map<String, dynamic>;
        return AuthSessionModel.fromJson(sessionMap);
      }
      return null;
    } catch (e) {
      print('Error getting session: $e');
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    try {
      final sessionJson = jsonEncode(session.toJson());
      await _prefs.setString(_sessionKey, sessionJson);
    } catch (e) {
      print('Error saving session: $e');
      throw Exception('Failed to save session');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _prefs.remove(_sessionKey);
    } catch (e) {
      print('Error clearing session: $e');
      throw Exception('Failed to clear session');
    }
  }
}
