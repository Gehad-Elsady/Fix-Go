import 'package:flutter/material.dart';

class PartnersPart extends StatelessWidget {
  const PartnersPart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), // Rounded corners
                image: DecorationImage(
                  image: AssetImage("assets/images/bmw.jpg"),
                  fit: BoxFit.fill, // Adjust fit as needed
                ),
              ),
              height: 200, // Set the height of the container
              width: 200, // Set the width of the container
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Rounded corners
                image: DecorationImage(
                  image: AssetImage("assets/images/logoun.jpg"),
                  fit: BoxFit.contain, // Adjust fit as needed
                ),
              ),
              height: 200, // Set the height of the container
              width: 300, // Set the width of the container
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Rounded corners
                image: DecorationImage(
                  image: AssetImage("assets/images/yBBW3VqKmcd2VXY72noNq8.jpg"),
                  fit: BoxFit.contain, // Adjust fit as needed
                ),
              ),
              height: 200, // Set the height of the container
              width: 200, // Set the width of the container
            ),
          ],
        ),
      ),
    );
  }
}
