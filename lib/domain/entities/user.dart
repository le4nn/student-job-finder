import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? phone;
  final UserRole role;
  final String? name;
  final bool isVerified;

  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.role,
    this.name,
    this.isVerified = false,
  });

  @override
  List<Object?> get props => [id, email, phone, role, name, isVerified];
}

enum UserRole {
  student,
  employer,
  admin;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'employer':
        return UserRole.employer;
      case 'admin':
        return UserRole.admin;
      default:
        throw ArgumentError('Unknown user role: $value');
    }
  }

  String get value {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.employer:
        return 'employer';
      case UserRole.admin:
        return 'admin';
    }
  }
}
