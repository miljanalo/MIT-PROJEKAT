enum UserRole { user, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.user
  });
}