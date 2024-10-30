import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = 'cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      Text('Shopping Cart'),
      Divider(),
    ]));
  }
}
