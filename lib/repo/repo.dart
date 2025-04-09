// ignore_for_file: unnecessary_cast

import 'package:hive/hive.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Open the Hive box
  Future<Box> _getBox() async {
    return await Hive.openBox('servicesBox');
  }

  // Fetch services from Firebase and cache them
  Future<List<ServiceModel>> fetchServices() async {
    try {
      // Fetch from Firestore
      final snapshot = await _firestore.collection('services').get();
      final List<ServiceModel> services = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ServiceModel(
          userId: data['userId'] ?? "no id",
          name: data['name'] ?? 'No Name',
          image: data['image'] ?? 'default_image.png',
          description: data['description'] ?? 'No Description',
          price: data['price'] ?? 'No Price',
          createdAt: data['createdAt'] ?? 'No Date',
        );
      }).toList();

      // Cache services in Hive
      final box = await _getBox();
      await box.put('services', services);

      return services;
    } catch (e) {
      throw Exception('Failed to fetch services from Firebase: $e');
    }
  }

  // Load services from the Hive cache
  Future<List<ServiceModel>> getCachedServices() async {
    final box = await _getBox();
    final cachedServices = box.get('services');

    if (cachedServices != null) {
      return List<ServiceModel>.from(cachedServices);
    } else {
      return [];
    }
  }
}
