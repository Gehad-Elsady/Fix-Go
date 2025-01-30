class UserModel {
  String name;
  String email;
  int age;
  String id;
  String role;

  UserModel(
      {required this.name,
      required this.email,
      required this.age,
      required this.role,
      this.id = ""});

  UserModel.fromJason(Map<String, dynamic> jason)
      : this(
          name: jason["name"],
          email: jason["email"],
          id: jason["id"],
          age: jason["age"],
          role: jason[
              "role"], // default role to 'user' if not provided in JSON data.
        );

  Map<String, dynamic> toJason() {
    return {"name": name, "email": email, "id": id, "age": age, "role": role};
  }
}
