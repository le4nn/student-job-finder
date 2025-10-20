class ApiConfig {
  static const String baseUrl = 'http://localhost:8081/api/';

  static const String requestCode = 'request-code';
  static const String verifyCode = 'verify-code';
  static const String register = 'auth/register';
  static const String refresh = 'auth/refresh';
  static const String logout = 'auth/logout';

  static const String health = 'health';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}

class ApiResponseFormat {
  static const String requestCodeSuccess = '''
  {
    "phone": "+77001234567",
    "code": "123456"
  }
  ''';

  static const String verifyCodeSuccess = '''
  {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "64f8a1b2c3d4e5f6a7b8c9d0",
      "phone": "+77001234567",
      "role": "student",
      "name": ""
    },
    "expiresAt": 1697544000
  }
  ''';

  static const String registerSuccess = '''
  {
    "success": true,
    "message": "User registered successfully",
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
        "id": "user_456",
        "email": "newuser@example.com",
        "role": "student",
        "name": "Jane Doe"
      },
      "expires_at": "2024-01-01T00:00:00Z"
    }
  }
  ''';
}
