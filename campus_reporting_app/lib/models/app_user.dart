import 'package:campus_reporting_app/enum/user_role_enum.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final UserRoleEnum role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  // Receiving data from Firestone or API and converting raw map to Dart object
  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      name: map['name'] as String,
      email: map['email'] as String,
      role: UserRoleEnum.values.firstWhere(
        (role) => role.name == map['role'],
        orElse: () => UserRoleEnum.student,
      ),
      createdAt: (map['createdAt'] as dynamic).toDate(),
      updatedAt: map['updatedAt'] == null
          ? null
          : (map['updatedAt'] as dynamic).toDate(),
    );
  }

  // Sending or saving data back to firebase, converting Dart object to raw map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
