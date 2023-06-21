class UserModel {
  final String name;
  final String uid;
  final String email;
  final String password;
  final List? books;

  UserModel(
      {required this.uid,
      required this.name,
      required this.email,
      this.books,
      required this.password});
  Map<String, dynamic> getJson() =>
      {"name": name, "email": email, "password": password, "uid": uid};
}
