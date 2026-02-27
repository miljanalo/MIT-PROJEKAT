enum UserRole { user, admin }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = UserRole.user,
    this.profileImage
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? profileImage,
  }){
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      role: role
    );
  }
}