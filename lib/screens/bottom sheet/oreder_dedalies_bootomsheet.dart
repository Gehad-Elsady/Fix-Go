import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/screens/Provider/location/order_location.dart';
import 'package:road_mate/screens/bottom%20sheet/widgets/location_user_provider.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';

class OrderDetailsBottomSheet extends StatelessWidget {
  final HistoryModel historyModel;

  const OrderDetailsBottomSheet({
    Key? key,
    required this.historyModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      // padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationUserProvider(
              longitude: historyModel.providerLocationModel!.longitude,
              latitude: historyModel.providerLocationModel!.latitude,
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "provider-info".tr(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("total-price".tr(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(width: 10),
                  Text("${historyModel.totalPrice} \$",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      historyModel.profileModel!.profileImage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      InfoRow(
                        label: "name".tr(),
                        value:
                            "${historyModel.profileModel!.firstName} ${historyModel.profileModel!.lastName}",
                      ),
                      const SizedBox(height: 15),
                      InfoRow(
                        label: "phone-number".tr(),
                        value: historyModel.profileModel!.phoneNumber,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
          ),
          children: [
            TextSpan(
              text: "$label: ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
