class Car {
  final String id;
  final String make;
  final String model;
  final String year;
  final String licensePlate;
  final String color;
  final String vin;

  Car({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.color,
    required this.vin,
  });

  // Convert Car to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': id,
      'make': make,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'color': color,
      'vin': vin,
    };
  }

  // Create Car from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['userId'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as String,
      licensePlate: json['licensePlate'] as String,
      color: json['color'] as String,
      vin: json['vin'] as String,
    );
  }
}
