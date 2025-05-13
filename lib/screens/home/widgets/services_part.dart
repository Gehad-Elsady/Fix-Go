import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';
import 'package:road_mate/screens/bottom%20sheet/request_bootomsheet.dart';

class ServicesPart extends StatelessWidget {
  const ServicesPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ServiceModel>>(
      stream: FirebaseFunctions.getServicesStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No services available'));
        }

        List<ServiceModel> serviceModel = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 115 / 156, // Adjusted for exact width & height
          ),
          itemCount: serviceModel.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return RequestBottomSheet(
                        serviceModel: serviceModel[index],
                        orderType: "Quick Order");
                  },
                );
              },
              child: Card(
                color: Color(0xffF6F6F6),
                child: SizedBox(
                  width: 115,
                  height: 156,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(
                                  8)), // Optional: Rounded corners
                          child: Image.asset(
                            "assets/images/services/${serviceModel[index].name}.png",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit
                                .contain, // Ensures the image fills the available space
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          serviceModel[index].name,
                          style: GoogleFonts.lora(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xff303539),
                              size: 15,
                            ),
                            Text(
                              "4.25",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
