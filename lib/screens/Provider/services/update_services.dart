import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_mate/screens/Provider/add-services/model/service-model.dart';

class UpdateServices extends StatefulWidget {
  static const String routeName = 'update_services';
  const UpdateServices({super.key});

  @override
  State<UpdateServices> createState() => _UpdateServicesState();
}

class _UpdateServicesState extends State<UpdateServices> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  Timestamp? _createdAt;

  bool _isUploading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve arguments passed to the page
    final data = ModalRoute.of(context)!.settings.arguments as ServiceModel?;

    // Initialize controllers and image
    if (data != null) {
      _nameController.text = data.name ?? '';
      _priceController.text = data.price?.toString() ?? '';
      _createdAt = data.createdAt;
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);
      String? imageUrl;

      // If the image is a new file, upload it, otherwise use the network URL

      if (imageUrl != null) {
        // Query to find the document based on `id` and `createdAt`
        final querySnapshot = await FirebaseFirestore.instance
            .collection('services')
            .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('createdAt', isEqualTo: _createdAt)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // If the document exists, update it
          final docId = querySnapshot.docs.first.id;
          await FirebaseFirestore.instance
              .collection('services')
              .doc(docId)
              .update({
            'name': _nameController.text.trim(),
            'price': _priceController.text.trim(),
            'image': imageUrl,
            'updatedAt': Timestamp.now(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Service updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Service not found or already updated'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isUploading = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'update-service'.tr(),
          style: GoogleFonts.lora(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'servec-details'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'add-service-name'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a name' : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'add-service-price'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter a price' : null,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'image'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _updateService,
                    child: Text('update-service'.tr(),
                        style: GoogleFonts.lora(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffADE1FB),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
