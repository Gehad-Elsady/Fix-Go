import 'package:road_mate/screens/add-services/model/service-model.dart';

abstract class ServiceStates {}

class ServiceInitState extends ServiceStates {}

class ServiceLoadingState extends ServiceStates {}

class ServiceErrorState extends ServiceStates {}

class ServiceSuccessState extends ServiceStates {
  final List<ServiceModel> services;

  // Constructor to accept the list of services
  ServiceSuccessState({required this.services});
}
