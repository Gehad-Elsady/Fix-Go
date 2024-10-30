import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:road_mate/Models/profilemodel.dart';
import 'package:road_mate/firebase_functions.dart';
import 'package:road_mate/theme/app-colors.dart';
import 'package:road_mate/validation/validation.dart';
import 'package:road_mate/widget/mydrawer.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = "user-profile";
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _imageFile;
  String? _downloadURL;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final picker = ImagePicker();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController points = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    address.dispose();
    contactNumber.dispose();
    city.dispose();
    state.dispose();
    points.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        String fileName = _imageFile!.path.split('/').last;
        Reference storageRef = _storage.ref().child('profile/$fileName');
        await storageRef.putFile(_imageFile!);

        String downloadURL = await storageRef.getDownloadURL();
        setState(() {
          _downloadURL = downloadURL;
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0091ad),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.backGround,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFunctions.getUserProfile(
              FirebaseAuth.instance.currentUser!.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            ProfileModel userProfile = snapshot.data!;
            firstName.text = userProfile.firstName ?? "";
            lastName.text = userProfile.lastName ?? "";
            email.text = userProfile.email ?? "";
            address.text = userProfile.address ?? "";
            contactNumber.text = userProfile.phoneNumber ?? "";
            city.text = userProfile.city ?? "";
            state.text = userProfile.state ?? '';
            _downloadURL = userProfile.profileImage ?? "";

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : _downloadURL != null &&
                                          _downloadURL!.isNotEmpty
                                      ? NetworkImage(_downloadURL!)
                                      : AssetImage('assets/placeholder.png')
                                          as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Total Points: ${points.text.isEmpty ? '0' : points.text} P',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: firstName,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your first name' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: lastName,
                            decoration: const InputDecoration(
                              labelText: 'Last Name',
                            ),
                            validator: (value) =>
                                value!.isEmpty ? 'Enter your last name' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        suffixIcon:
                            const Icon(Icons.check_circle, color: Colors.green),
                      ),
                      validator: Validation.validateEmail(email.text),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: address,
                      decoration: const InputDecoration(labelText: 'Address'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your address' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: contactNumber,
                      decoration:
                          const InputDecoration(labelText: 'Contact Number'),
                      validator: (value) =>
                          value!.isEmpty ? 'Enter your contact number' : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: city.text.isEmpty ? null : city.text,
                            items: ['Mehrab', 'City 2', 'City 3']
                                .map((city) => DropdownMenuItem(
                                    value: city, child: Text(city)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => city.text = value!),
                            decoration:
                                const InputDecoration(labelText: 'City'),
                            validator: (value) =>
                                value == null ? 'Select a city' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: state.text.isEmpty ? null : state.text,
                            items: ['Bozorgi', 'State 2', 'State 3']
                                .map((state) => DropdownMenuItem(
                                    value: state, child: Text(state)))
                                .toList(),
                            onChanged: (value) =>
                                setState(() => state.text = value!),
                            decoration:
                                const InputDecoration(labelText: 'State'),
                            validator: (value) =>
                                value == null ? 'Select a state' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                          ),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _uploadImage();
                            if (_formKey.currentState!.validate()) {
                              ProfileModel data = ProfileModel(
                                firstName: firstName.text,
                                lastName: lastName.text,
                                address: address.text,
                                phoneNumber: contactNumber.text,
                                city: city.text,
                                state: state.text,
                                email: email.text,
                                profileImage: _downloadURL!,
                                id: FirebaseAuth.instance.currentUser!.uid,
                              );
                              FirebaseFunctions.addUserProfile(data);
                              firstName.clear();
                              lastName.clear();
                              address.clear();
                              contactNumber.clear();
                              city.clear();
                              state.clear();
                              email.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Profile Saved!')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
