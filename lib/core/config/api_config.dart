class ApiConfig {
  static const String
  baseUrl = 'http://localhost:8081';

  static const String registerPassword = '$baseUrl/auth/register-password';
  static const String loginPassword = '$baseUrl/auth/login-password';
  
  static const String requestEmailCode = '$baseUrl/auth/request-email-code';
  static const String verifyEmailCode = '$baseUrl/auth/verify-email-code';
  
  static const String requestPhoneCode = '$baseUrl/auth/request-phone-code';
  static const String verifyPhoneCode = '$baseUrl/auth/verify-phone-code';
  
  static const String requestCode = '$baseUrl/api/request-code';
  static const String verifyCode = '$baseUrl/api/verify-code';
  static const String register = '$baseUrl/auth/register';
  static const String refresh = '$baseUrl/auth/refresh';
  static const String logout = '$baseUrl/auth/logout';

  static const String health = '$baseUrl/api/health';

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
