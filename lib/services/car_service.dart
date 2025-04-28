import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_mate/screens/cars/models/car.dart';

class CarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get the cars collection reference
  CollectionReference get _carsCollection => _firestore.collection('cars');

  // Add a new car
  Future<Car> addCar(Car car) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final carData = car.toJson(); // Add user ID to car data

      final docRef = await _carsCollection.add(carData);
      return Car(
        id: car.id,
        make: car.make,
        model: car.model,
        year: car.year,
        licensePlate: car.licensePlate,
        color: car.color,
        vin: car.vin,
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
        return Car.fromJson(doc.data() as Map<String, dynamic>);
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
      carData['userId'] = userId; // Ensure user ID is included in update

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

      // Verify the car belongs to the current user before deleting
      final carDoc = await _carsCollection.doc(carId).get();
      final carData = carDoc.data() as Map<String, dynamic>?;

      if (carDoc.exists && carData != null && carData['userId'] == userId) {
        await _carsCollection.doc(carId).delete();
      } else {
        throw Exception('Car not found or unauthorized');
      }
    } catch (e) {
      throw Exception('Failed to delete car: $e');
    }
  }
}
