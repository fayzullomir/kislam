class User {
  int id;
  String? firstName;
  String? lastName;
  String? email;
  String? photo;
  String? userRole;

  User({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.photo,
    this.userRole,
  });

  String get fullName => '${firstName ?? ""} ${lastName ?? ""}'.trim();
}
