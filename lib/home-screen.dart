import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/photos/photos.dart';
import 'package:road_mate/theme/app-colors.dart';
import 'package:road_mate/widget/mydevider.dart';
import 'package:road_mate/widget/mydrawer.dart';
import 'package:road_mate/widget/services-part.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home-screen';
  HomeScreen({super.key});

  // List of images for the Carousel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              Photos.logo,
              height: 40,
            ),
            SizedBox(width: 10), // Added spacing between logo and title
            Text(
              'Fix & Go',
              style: GoogleFonts.domine(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ), // Applying Domine font to the title
            ),
          ],
        ),
        backgroundColor: Color(0xFF0091ad),
      ),
      body: SingleChildScrollView(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.backGround,
            ),
          ),
          child: Column(
            children: [
              // Carousel Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  pauseAutoPlayOnManualNavigate:
                      true, // Updated to newer option
                  enlargeCenterPage: true, // Optionally enlarge the center page
                ),
                items: Photos.appBar.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Optional: rounded corners
                          child: Image.asset(
                            i,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Text(
                                      'Image not found')); // Handle image load error
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              SizedBox(
                  height:
                      20), // Adding some spacing between carousel and grid of images
              MyDivider(
                text: "services",
              ),
              // show what services we offer
              ServicesPart(),
              MyDivider(text: "Our partners"),
              // Fixed height for GridView
              Container(
                height: 400, // Set fixed height for GridView
                padding: EdgeInsets.all(10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
