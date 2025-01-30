import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:road_mate/backend/bloc/cubit.dart';
import 'package:road_mate/backend/bloc/states.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/location/location.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/profile/model/profilemodel.dart';
import 'package:road_mate/widget/services-item.dart';

class ServicesPart extends StatelessWidget {
  ServicesPart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 335, // Adjust height as needed
      child: BlocProvider(
        create: (context) => ServiceCubit()..getServices(),
        child: BlocConsumer<ServiceCubit, ServiceStates>(
          builder: (context, state) {
            if (state is ServiceLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is ServiceErrorState) {
              return Center(child: Text('No services available.'));
            }

            if (state is ServiceSuccessState) {
              final services = state.services; // Get services from the state
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return SizedBox(
                    width: 200, // Adjust width as needed
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ServicesItem(
                        service: service,
                        buttonTitle: "quick-order".tr(),
                        callBack: () async {
                          try {
                            // Fetch the user profile
                            ProfileModel? profileModel =
                                await FirebaseFunctions.getUserProfile(
                                        FirebaseAuth.instance.currentUser!.uid)
                                    .first;

                            if (profileModel == null) {
                              // Show an alert dialog if the profile is null
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('no-profile'.tr()),
                                    content: Text(
                                        'No profile data available please complete your profile first.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('ok'.tr()),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // Log the user's name for debugging
                              print(
                                  '--------------Name is ${profileModel.firstName}');

                              // Create a HistoryModel instance
                              final historymaodel = HistoryModel(
                                serviceModel: service,
                                orderType: "Quick Order",
                              );

                              // Navigate to the GPS screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Gps(
                                    historymaodel: historymaodel,
                                    totalPrice: int.parse(service.price),
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            // Handle exceptions and display an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }

            return Container(); // Default case, should not be reached
          },
          listener: (context, state) {},
        ),
      ),
    );
  }
}
