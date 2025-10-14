class ApiConfig {
  static const String baseUrl = 'https://api.jobfinder.kz/v1/';
  
  static const String sendOtp = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
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
  static const String sendOtpSuccess = '''
  {
    "success": true,
    "message": "OTP sent successfully",
    "data": {
      "phone": "+7 (777) 777 77 77",
      "expires_in": 300
    }
  }
  ''';
  
  static const String verifyOtpSuccess = '''
  {
    "success": true,
    "message": "OTP verified successfully",
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
        "id": "user_123",
        "email": "user@example.com",
        "phone": "+7 (777) 777 77 77",
        "role": "student",
        "name": "John Doe"
      },
      "expires_at": "2024-01-01T00:00:00Z"
    }
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
