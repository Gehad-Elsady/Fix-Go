// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:road_mate/repo/repo.dart';
// import 'package:road_mate/screens/add-services/model/service-model.dart';

// class ServiceRemoteDsImpl extends ServiceRepo {
//   @override
//   Future<ServiceModel> getService() async {
//     final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     try {
//       // Fetch the data from Firestore
//       final snapshot = await _firestore.collection('services').get();

//       // Check if the snapshot contains any documents
//       if (snapshot.docs.isEmpty) {
//         return ServiceModel(
//           userId: "no id",
//           name: "No Name",
//           image: "default_image.png",
//           description: "No Description",
//           price: "No Price",
//         ); // Return a default ServiceModel if no data is found
//       }

//       // Extract the first service from the snapshot
//       final data = snapshot.docs.first.data() as Map<String, dynamic>;

//       return ServiceModel(
//         userId: data['userId'] ?? "no id",
//         name: data['name'] ?? 'No Name',
//         image: data['image'] ?? 'default_image.png',
//         description: data['description'] ?? 'No Description',
//         price: data['price']?.toString() ?? 'No Price',
//       );
//     } catch (e) {
//       // Handle any errors during the Firestore request
//       print("Error fetching services: $e");
//       return ServiceModel(
//         userId: "no id",
//         name: "No Name",
//         image: "default_image.png",
//         description: "No Description",
//         price: "No Price",
//       ); // Return a default ServiceModel in case of error
//     }
//   }
// }
