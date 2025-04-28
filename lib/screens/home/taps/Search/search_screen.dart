import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/bottom%20sheet/request_bootomsheet.dart';

class ServicesSearchPage extends StatefulWidget {
  static const String routeName = '/services-search';
  const ServicesSearchPage({super.key});

  @override
  _ServicesSearchPageState createState() => _ServicesSearchPageState();
}

class _ServicesSearchPageState extends State<ServicesSearchPage> {
  String query = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Search Services",
            style: GoogleFonts.lora(
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search TextField
              TextField(
                onChanged: (value) {
                  setState(() {
                    query = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search for services...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // StreamBuilder to search in the courses collection
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('services').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No courses found."));
                    }

                    final results = snapshot.data!.docs.where((doc) {
                      final name = doc['name']?.toString().toLowerCase() ??
                          ''; // Handle null values

                      return name.contains(query);
                    }).toList();

                    if (results.isEmpty) {
                      return const Center(
                          child: Text("No matching courses found."));
                    }

                    return ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final services = results[index];

                        final servicesModel = ServiceModel.fromJson(
                            services.data() as Map<String, dynamic>);

                        return InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              isDismissible: true,
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return RequestBottomSheet(
                                    serviceModel: servicesModel,
                                    orderType: "Quick Order");
                              },
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                            color: Color(0xffADE1FB),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shadowColor: Colors.black26,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/images/services/${servicesModel.name}.png",
                                        height: 100,
                                        width: 100,
                                      )),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        servicesModel.name,
                                        style: GoogleFonts.lora(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '\$${servicesModel.price}',
                                        style: GoogleFonts.lora(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
