import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_mate/screens/cars/models/car.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _carsCollection => _firestore.collection('cars');

  // Add a new car (max 2 cars per user)
  Future<Car> addCar(Car car) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // 🔍 Check if the user already has 2 cars
      final existingCars = await _carsCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (existingCars.docs.length >= 2) {
        throw Exception('Car limit reached. You can only add up to 2 cars.');
      }

      final carData = car.toJson();
      carData['userId'] = userId;

      final docRef = await _carsCollection.add(carData);

      return Car(
        id: docRef.id,
        make: car.make,
        model: car.model,
        year: car.year,
        licensePlate: car.licensePlate,
        color: car.color,
        vin: car.vin,
        userId: userId,
      );
    } catch (e) {
      throw Exception('Failed to add car: $e');
    }
  }

  // Get all cars for the current user
  Stream<List<Car>> getCars() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _carsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Inject document ID
        return Car.fromJson(data);
      }).toList();
    });
  }

  // Update a car
  Future<void> updateCar(Car car) async {
    try {
      if (car.id == null) throw Exception('Car ID is required for update');

      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final carData = car.toJson();
      carData['userId'] = userId;

      await _carsCollection.doc(car.id).update(carData);
    } catch (e) {
      throw Exception('Failed to update car: $e');
    }
  }

  // Delete a car
  Future<void> deleteCar(String carId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final carDoc = await _carsCollection.doc(carId).get();

      if (!carDoc.exists) {
        throw Exception('Car not found');
      }

      final carData = carDoc.data() as Map<String, dynamic>;
      if (carData['userId'] != userId) {
        throw Exception('Unauthorized to delete this car');
      }

      await _carsCollection.doc(carId).delete();
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }
}
