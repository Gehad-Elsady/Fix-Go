import 'package:flutter/material.dart';

class ThirdPart extends StatelessWidget {
  const ThirdPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap:
          true, // Allows GridView to be scrollable within the SingleChildScrollView
      physics: NeverScrollableScrollPhysics(), // Disable GridView's scrolling
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        childAspectRatio: 0.7,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        // final service = snapshot.data![index];
        return GestureDetector(
          onTap: () {
            // Navigator.pushNamed(context, InfoScreen.routeName,
            //     arguments: service);
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Rounded corners
            ),
            elevation: 5, // Shadow effect
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(16), // Rounded corners for the image
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.engineering,
                    size: 50,
                  ),
                  // Text for name and price
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "service.name",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
