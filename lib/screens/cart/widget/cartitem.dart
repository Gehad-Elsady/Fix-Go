import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/screens/add-services/model/service-model.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.service,
    required this.itemId,
  });

  final ServiceModel service;
  final String itemId;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  service.name,
                  // style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${service.price}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        FirebaseFunctions.deleteCartService(itemId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Item deleted successfully!'),
                          ),
                        );
                        // print(itemId);
                      },
                      child: Text('delete'.tr()),
                    ),
                    // Quantity Control (optional)
                  ],
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                service.image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
