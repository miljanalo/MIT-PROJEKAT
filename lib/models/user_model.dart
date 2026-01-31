enum UserRole { user, admin }

class UserModel {
  final String name;
  final String email;
  final UserRole role;

  UserModel({
    required this.name,
    required this.email,
    this.role = UserRole.user
  });
}