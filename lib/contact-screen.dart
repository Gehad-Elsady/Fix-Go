import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  static const String routeName = 'contact-screen';
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text('Contact Screen'),
        ],
      ),
    );
  }
}
