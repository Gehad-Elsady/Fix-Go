import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddServicePage extends StatefulWidget {
  static const String routeName = 'AddServicePage';

  @override
  _AddServicePageState createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedServiceName;

  final List<String> _serviceNames = [
    'Over heating',
    'Steering repair',
    'Tyre change',
    'Oil change',
    'Car tow',
    'Batteries',
  ];
  // File? _image;
  // final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       _image = File(pickedFile.path);
  //     });
  //   }
  // }

  // Future<String?> _uploadImage(File image) async {
  //   try {
  //     final storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('service_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
  //     final uploadTask = await storageRef.putFile(image);
  //     return await uploadTask.ref.getDownloadURL();
  //   } catch (e) {
  //     print("Error uploading image: $e");
  //     return null;
  //   }
  // }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUploading = true);

      await FirebaseFirestore.instance.collection('services').add({
        'name': _selectedServiceName,
        'price': _priceController.text.trim(),
        'createdAt': Timestamp.now(),
        'userId': FirebaseAuth.instance.currentUser!.uid
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Service added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Go back after saving
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(
      //       content: Text('Failed to upload image'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'add-service'.tr(),
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
                      _buildDropdownField(
                          'Service Name',
                          _serviceNames,
                          _selectedServiceName,
                          (value) =>
                              setState(() => _selectedServiceName = value)),
                      // SizedBox(height: 16),
                      // TextFormField(
                      //   controller: _descriptionController,
                      //   decoration: InputDecoration(
                      //     labelText: 'add-service-description'.tr(),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(8.0),
                      //     ),
                      //   ),
                      //   maxLines: 3,
                      //   validator: (value) => value!.isEmpty
                      //       ? 'Please enter a description'
                      //       : null,
                      // ),
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
                      // Text(
                      //   'image'.tr(),
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      // SizedBox(height: 16),
                      // _image == null
                      //     ? Text(
                      //         'image-error'.tr(),
                      //         style: TextStyle(color: Colors.grey),
                      //         textAlign: TextAlign.center,
                      //       )
                      //     : ClipRRect(
                      //         borderRadius: BorderRadius.circular(8.0),
                      //         child: Image.file(_image!, height: 150),
                      //       ),
                      SizedBox(height: 10),
                      // OutlinedButton.icon(
                      //   onPressed: _pickImage,
                      //   icon: Icon(Icons.image),
                      //   label: Text('pick-image'.tr()),
                      //   style: OutlinedButton.styleFrom(
                      //     padding: EdgeInsets.symmetric(vertical: 16),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            _isUploading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _saveService,
                    child: Text('add-service'.tr(),
                        style: GoogleFonts.lora(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff01082D),
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

Widget _buildDropdownField(String label, List<String> items,
    String? selectedValue, ValueChanged<String?> onChanged) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: DropdownButtonFormField<String>(
      style: TextStyle(color: Colors.black, fontSize: 16),
      dropdownColor: Color(0xffADE1FB),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        // Define the border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
          borderSide: const BorderSide(
            color: Colors.black, // Border color
            width: 2.0, // Border width
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black, // Border color when enabled
            width: 2.0, // Border width
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black, // Border color when focused
            width: 2.0, // w width
          ),
        ),
      ),
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    ),
  );
}
