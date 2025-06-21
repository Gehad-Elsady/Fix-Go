class Car {
  final String? id;
  final String make;
  final String model;
  final int year;
  final String licensePlate;
  final String color;
  final String vin;
  final String? userId;

  Car({
    this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.vin,
    this.userId,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['licensePlate'],
      color: json['color'],
      vin: json['vin'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'color': color,
      'vin': vin,
      'userId': userId,
    };
  }
}
