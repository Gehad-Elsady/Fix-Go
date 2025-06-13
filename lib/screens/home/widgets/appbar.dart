import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/constants/photos/photos.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        pauseAutoPlayOnManualNavigate: true, // Updated to newer option
        enlargeCenterPage: true, // Optionally enlarge the center page
      ),
      items: Photos.appBar.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(10), // Optional: rounded corners
                child: Image.asset(
                  i,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                        child:
                            Text('Image not found')); // Handle image load error
                  },
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
