import 'dart:async'; // For Timer
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/history/model/historymaodel.dart';
import 'package:road_mate/widget/drawer/mydrawer.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = 'history';
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // A method to periodically check for expired time and refresh the UI
  void startTimer(Duration duration, void Function() onTimeout) {
    Timer(
        duration, onTimeout); // After the time passes, the callback is executed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<HistoryModel>>(
          stream: FirebaseFunctions.getHistoryStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
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

                // Handling null timestamp with a fallback
                DateTime timestamp = history.timestamp != null
                    ? DateTime.fromMillisecondsSinceEpoch(history.timestamp!)
                    : DateTime.now();
                DateTime now = DateTime.now();
                Duration timeDiff = now.difference(timestamp);

                // Show cancel button only if the order was placed within 5 minutes
                bool enableCancelButton = timeDiff.inMinutes < 5;

                // Start a timer to refresh the UI after 5 minutes
                if (enableCancelButton) {
                  startTimer(Duration(seconds: 300 - timeDiff.inSeconds), () {
                    setState(() {}); // Trigger a rebuild to refresh the UI
                  });
                }

                String formattedTime = DateFormat('yyyy-MM-dd HH:mm a')
                    .format(timestamp.toLocal());

                return Card(
                  color: Colors.blueAccent[100],
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${"service-type".tr()}: ${history.orderType ?? 'N/A'}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${"timestamp".tr()}: ${formattedTime}",
                          style: TextStyle(fontSize: 16),
                        ),

                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'order-status'.tr() + ': ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                              history.orderStatus == 'Pending'
                                  ? TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : TextSpan(
                                      text: history.orderStatus,
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 20,
                                      ),
                                    )
                            ],
                          ),
                        ),

                        // Display Quick Order data
                        if (history.serviceModel != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${"add-service-name".tr()}: ${history.serviceModel!.name}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  "${"add-service-description".tr()}: ${history.serviceModel!.description}",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Text(
                                  "${"add-service-price".tr()}: ${history.serviceModel!.price}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Image.network(
                                  history.serviceModel!.image,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),

                        // Display Cart Order data
                        if (history.items != null && history.items!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: history.items!.map((item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Service Name: ${item.serviceModel.name}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Service Description: ${item.serviceModel.description}",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                    Text(
                                      "Price: ${item.serviceModel.price}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Image.network(
                                      item.serviceModel.image,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                        SizedBox(height: 10),

                        // Display a countdown for cancel eligibility if within 5 minutes
                        if (enableCancelButton)
                          Text(
                            "Cancel within ${5 - timeDiff.inMinutes} minutes",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        SizedBox(height: 10),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0091ad),
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
                                : null, // Disable the button if not within the cancellation time
                            child: Text(
                              "cancel".tr(),
                              style: TextStyle(
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
      ),
    );
  }
}
