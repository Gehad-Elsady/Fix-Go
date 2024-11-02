import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/screens/add-services/model/service-model.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/widget/services-item.dart';

class ServicesPart extends StatelessWidget {
  ServicesPart({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 335, // Adjust height as needed
      child: StreamBuilder<List<ServiceModel>>(
        stream: FirebaseFunctions.getServicesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No services available.'));
          }

          final services = snapshot.data!;

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
                    callBack: () {
                      // Navigator.pushNamed(context, AddServicePage.routeName);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
