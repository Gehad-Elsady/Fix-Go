// ignore_for_file: unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_mate/backend/bloc/states.dart';
import 'package:road_mate/screens/add-services/model/service-model.dart';

class ServiceCubit extends Cubit<ServiceStates> {
  ServiceCubit() : super(ServiceInitState());

  static ServiceCubit get(context) => BlocProvider.of(context);

  Future<void> getServices() async {
    try {
      emit(ServiceLoadingState());
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final snapshot = await _firestore.collection('services').get();
      final services = snapshot.docs.map((doc) {
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
      emit(ServiceSuccessState(services: services));
    } catch (e) {
      emit(ServiceErrorState());
    }
  }
}
