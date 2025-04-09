class UserModel {
  String firstName;
  String lastName;
  String email;
  int phoneNumber;
  String id;
  String role;
  String? imageUrl;

  UserModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.role,
      this.imageUrl,
      this.id = ""});

  UserModel.fromJason(Map<String, dynamic> jason)
      : this(
          firstName: jason["name"],
          lastName: jason["lastName"],
          email: jason["email"],
          id: jason["id"],
          phoneNumber: jason["phoneNumber"],
          role: jason[
              "role"], // default role to 'user' if not provided in JSON data.
          imageUrl: jason["imageUrl"],
        );

  Map<String, dynamic> toJason() {
    return {
      "name": firstName,
      "lastName": lastName,
      "email": email,
      "id": id,
      "phoneNumber": phoneNumber,
      "role": role,
      "imageUrl": imageUrl,
    };
  }
}
