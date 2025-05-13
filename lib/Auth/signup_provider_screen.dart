import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:road_mate/Auth/login-screen.dart';
import 'package:road_mate/backend/firebase_functions.dart';
import 'package:road_mate/constants/photos/photos.dart';

class SignupProvider extends StatefulWidget {
  static const String routeName = 'signup-provider-screen';
  const SignupProvider({super.key});

  @override
  State<SignupProvider> createState() => _SignupProviderState();
}

class _SignupProviderState extends State<SignupProvider> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false, // User must tap the button to close
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Important Notice'),
            content: SingleChildScrollView(
              child: Text(
                '''Welcome to FIX&GO!

Dear Provider,

Thank you for your interest in joining our app, your trusted partner for road assistance services. Before you complete your registration, please review the following important guidelines to ensure a smooth and professional experience:

1. Provider Subscription:
   - A subscription fee of 20 LE per month is required to access and operate through our platform.

2. Response Time:
   - Providers are expected to respond promptly to service requests to maintain customer satisfaction.

3. Availability:
   - Keep your availability status updated in the app to avoid missed requests.

4. Transaction Fees:
   - A 5% fee applies to each completed request.

5. Pricing Transparency:
   - Prices must be clear, fair, and include our platform fees. All prices must be agreed upon through the app.

6. Licensing and Insurance:
   - You must have the necessary licenses, permits, and insurance to provide legal road assistance services.

7. Customer Interaction:
   - Maintain professionalism, respect, and clear communication with customers at all times.

8. App Usage:
   - All service requests, communication, and payments must be conducted within the app.

9. Limitations:
   - You may only accept up to 3 active requests at a time to ensure system performance.
   - If you're the nearest provider and no one else accepts a request, you may be auto-assigned in emergencies.

By completing your registration, you agree to follow these guidelines and help us provide the best service possible.

We’re excited to have you on board!

— FIX&GO Team''',
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('I Agree'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('license_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 80),
                Text(
                  "Sign up as a provider",
                  style: GoogleFonts.lora(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "name-error".tr()
                                      : null,
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "name".tr(),
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 15),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                      ? "name-error".tr()
                                      : null,
                              controller: lastNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "Enter last name",
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 15),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "empty-email-error".tr();
                          }
                          final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                          ).hasMatch(value);
                          return emailValid ? null : "email-error".tr();
                        },
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "enter-email".tr(),
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: 15),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) => (value == null || value.isEmpty)
                            ? "age-error".tr()
                            : null,
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Enter phone number",
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'empty-pass-error'.tr();
                          }
                          final regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                          );
                          return regex.hasMatch(value)
                              ? null
                              : 'empty-pass-error-s'.tr();
                        },
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "enter-password".tr(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'empty-pass-error'.tr()
                            : (value != passwordController.text)
                                ? "Two passwords do not match"
                                : null,
                        controller: confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: "Re-enter your password",
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: Text(
                              _image == null
                                  ? "Upload your working license"
                                  : _image!.path,
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 15,
                              backgroundColor: const Color(0xff041D56),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _pickImage,
                            child: Text('Upload',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 15,
                          backgroundColor: const Color(0xffADE1FB),
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate() &&
                              _image != null) {
                            setState(() => _isUploading = true);
                            final imageUrl = await _uploadImage(_image!);
                            FirebaseFunctions.SignUp(
                              role: "Provider",
                              emailAddress: emailController.text,
                              password: passwordController.text,
                              phoneNumber:
                                  int.parse(phoneNumberController.text),
                              firstName: nameController.text,
                              lastName: lastNameController.text,
                              imageUrl: imageUrl!,
                              onSuccess: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(Photos.create),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Please Verify Your Email Address to Login",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                Timer(
                                  const Duration(seconds: 3),
                                  () => Navigator.pushNamed(
                                      context, LoginPage.routeName),
                                );
                              },
                              onError: (e) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Error"),
                                    content: Text(e.toString()),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            confirmPasswordController.clear();
                            phoneNumberController.clear();
                            lastNameController.clear();
                          }
                        },
                        child: const Text("Create my account"),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginPage.routeName);
                        },
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            text: "have-an-account".tr(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            children: [
                              TextSpan(
                                text: "login".tr(),
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
