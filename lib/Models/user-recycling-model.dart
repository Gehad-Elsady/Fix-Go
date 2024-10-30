class UserRecyclingModel {
  final String email;
  final String type;
  final int size;
  final String address;
  final String phone;

  UserRecyclingModel({
    required this.size,
    required this.email,
    required this.type,
    required this.address,
    required this.phone,
  });

  Map<String, dynamic> toJason() {
    return {
      "name": size,
      "email": email,
      "type": type,
      "address": address,
      "phone": phone,
    };
  }

  static UserRecyclingModel fromJson(Map<String, dynamic> json) {
    return UserRecyclingModel(
      size: json['name'],
      email: json['email'],
      type: json['type'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
