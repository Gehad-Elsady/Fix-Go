import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/notifications/notification_back.dart';
import 'package:road_mate/screens/Provider/home/model/accepted_model.dart';
import 'package:road_mate/screens/Provider/location/order_location.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';

class RequestsPart extends StatelessWidget {
  const RequestsPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 375, // Set a fixed height for horizontal cards
      child: StreamBuilder<List<HistoryModel>>(
        stream: FirebaseFunctions.getAdminRequestStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading history: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("request-empty".tr()));
          }

          final historyList = snapshot.data!;
          return SizedBox(
            height: 395, // Set a fixed height for horizontal cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                final history = historyList[index];

                DateTime timestamp = history.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                    : DateTime.now();
                String formattedTime = DateFormat('yyyy-MM-dd HH:mm a')
                    .format(timestamp.toLocal());

                const whiteTextStyle =
                    TextStyle(color: Colors.white, fontSize: 18);
                const boldWhiteTextStyle = TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold);

                return SingleChildScrollView(
                  child: Container(
                    width: 198, // Card width for horizontal layout
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: Card(
                      color: Color(0xff01082D),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(history.orderType ?? '',
                                style: whiteTextStyle),
                            SizedBox(height: 8),
                            Text(formattedTime, style: whiteTextStyle),
                            Text(history.orderOwnerName ?? 'No Name',
                                style: whiteTextStyle),
                            Text(history.orderOwnerPhone ?? 'No Phone',
                                style: whiteTextStyle),
                            TextButton(
                              onPressed: () {
                                if (history.locationModel != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OrderLocation(
                                        longitude:
                                            history.locationModel!.longitude,
                                        latitude:
                                            history.locationModel!.latitude,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text("order-location".tr(),
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            if (history.serviceModel != null) ...[
                              SizedBox(height: 4),
                              Text(history.serviceModel!.name,
                                  style: whiteTextStyle),
                              Text(history.serviceModel!.price + " EGP",
                                  style: whiteTextStyle),
                            ],
                            if (history.items != null &&
                                history.items!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: history.items!.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("${item.serviceModel.name}",
                                            style: whiteTextStyle),
                                        Text(item.serviceModel.price + " EGP",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            if (DateTime.now().difference(timestamp).inMinutes <
                                5)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                    "You can cancel this order within 5 minutes",
                                    style: TextStyle(color: Colors.orange)),
                              ),
                            SizedBox(height: 10),
                            Center(
                              child: history.orderStatus == 'Pending'
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF0091ad)),
                                      onPressed: () async {
                                        await FirebaseFunctions.acceptedOrder(
                                            history.userId!,
                                            history.timestamp!);
                                        AcceptedModel acceptedModel =
                                            AcceptedModel(
                                          historyModel: history,
                                          orderTime: DateTime.now()
                                              .millisecondsSinceEpoch,
                                          orderType: history.orderType!,
                                          totalPrice: history.totalPrice!,
                                          serviceModel: history.serviceModel,
                                          items: history.items,
                                          userId: FirebaseAuth
                                              .instance.currentUser!.uid,
                                          orderStatus: "Not completed",
                                        );
                                        FirebaseFunctions.addOrderToMyList(
                                            acceptedModel);
                                        NotificationBack.sendAcceptNotification(
                                            history.userId!);
                                      },
                                      child: Text("accept-order".tr(),
                                          style: boldWhiteTextStyle),
                                    )
                                  : Text("This order is already accepted",
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
