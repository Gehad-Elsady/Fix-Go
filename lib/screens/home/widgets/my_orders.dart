import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/bottom%20sheet/oreder_dedalies_bootomsheet.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  void startTimer(Duration duration, void Function() onTimeout) {
    Timer(duration, onTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Fixed height for horizontal list
      child: StreamBuilder<List<HistoryModel>>(
        stream: FirebaseFunctions.getHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("Error loading history: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("history-empty".tr()));
          }

          final historyList = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: historyList.length,
            itemBuilder: (context, index) {
              final history = historyList[index];

              DateTime timestamp = history.timestamp != null
                  ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                  : DateTime.now();
              DateTime now = DateTime.now();
              Duration timeDiff = now.difference(timestamp);
              bool enableCancelButton = timeDiff.inMinutes < 5;

              if (enableCancelButton) {
                startTimer(Duration(seconds: 300 - timeDiff.inSeconds), () {
                  setState(() {});
                });
              }

              String formattedTime =
                  DateFormat('yyyy-MM-dd HH:mm a').format(timestamp.toLocal());

              return GestureDetector(
                onTap: () {
                  history.orderStatus == 'Accepted'
                      ? showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          backgroundColor: Colors.white,
                          builder: (context) {
                            return OrderDetailsBottomSheet(
                              historyModel: history,
                            );
                          },
                        )
                      : null;
                },
                child: Container(
                  width: 300,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Card(
                    color: Colors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              "${"timestamp".tr()}: $formattedTime",
                              style: const TextStyle(fontSize: 16),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${"order-status".tr()}: ',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                  TextSpan(
                                    text: history.orderStatus,
                                    style: TextStyle(
                                      color: history.orderStatus == 'Pending'
                                          ? Colors.yellow
                                          : Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (history.serviceModel != null)
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${"add-service-name".tr()}: ${history.serviceModel!.name}",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "${"Car name"}: ${history.car!.make} ${history.car!.model}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${"Car License"}: ${history.car!.licensePlate}",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            "assets/images/services/${history.serviceModel!.name}.png",
                                            width: double.infinity,
                                            height: 80,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            if (history.items != null &&
                                history.items!.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: history.items!.map((item) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Service Name: ${item.serviceModel.name}",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                "${"Car name"}: ${history.car?.make ?? "error"} ${history.car?.model ?? "error"}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                "${"Car License"}: ${history.car?.licensePlate ?? "error"}",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.asset(
                                            "assets/images/services/${item.serviceModel.name}.png",
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Price: ",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  history.totalPrice.toString() +
                                      " \$", // Assuming totalPrice is a double
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0091ad),
                                ),
                                onPressed: history.orderStatus == 'Pending'
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("cancel-order".tr()),
                                              actions: [
                                                TextButton(
                                                  child: Text("yes".tr()),
                                                  onPressed: () {
                                                    FirebaseFunctions
                                                        .deleteHistoryOrder(
                                                            history.timestamp!);
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("no".tr()),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                child: Text(
                                  "cancel".tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
