import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/screens/home/main_hame.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  void startTimer(Duration duration, void Function() onTimeout) {
    Timer(duration, onTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "history".tr(),
          style: GoogleFonts.domine(
            fontSize: 30,
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, MainHome.routeName);
          },
        ),
      ),
      body: StreamBuilder<List<HistoryModel>>(
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

              return Card(
                color: Colors.blueAccent[100],
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${"service-type".tr()}: ${history.orderType ?? 'N/A'}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${"timestamp".tr()}: $formattedTime",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${"order-status".tr()}: ',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                            TextSpan(
                              text: history.orderStatus,
                              style: TextStyle(
                                color: history.orderStatus == 'Pending'
                                    ? Colors.yellow
                                    : Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Quick Order
                      if (history.serviceModel != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${"add-service-name".tr()}: ${history.serviceModel!.name}",
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${"add-service-price".tr()}: ${history.serviceModel!.price}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${"Car name"}: ${history.car!.make + "  " + history.car!.model}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${"Car License"}: ${history.car!.licensePlate}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                "assets/images/services/${history.serviceModel!.name}.png",
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ],
                        ),

                      // Cart Order
                      if (history.items != null && history.items!.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: history.items!.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Service Name: ${item.serviceModel.name}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Price: ${item.serviceModel.price}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${"Car name"}: ${history.car?.make ?? "error"}" +
                                        " " +
                                        "${history.car?.model ?? "error"}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${"Car License"}: ${history.car?.licensePlate ?? "error"}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/images/services/${item.serviceModel.name}.png",
                                      width: double.infinity,
                                      height: 100,
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

                      // Cancel countdown
                      if (enableCancelButton)
                        Text(
                          "Cancel within ${5 - timeDiff.inMinutes} minutes",
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),

                      const SizedBox(height: 10),

                      // Cancel button
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0091ad),
                          ),
                          onPressed: enableCancelButton
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
              );
            },
          );
        },
      ),
    );
  }
}
