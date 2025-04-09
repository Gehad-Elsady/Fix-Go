import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/screens/settings/bottom_sheets/language_bottomsheet.dart'; // Assuming you have this widget
import 'package:easy_localization/easy_localization.dart';

class ProviderSettings extends StatefulWidget {
  static const String routeName = "provider-settings";
  ProviderSettings({Key? key}) : super(key: key);

  @override
  State<ProviderSettings> createState() => _ProviderSettingsState();
}

class _ProviderSettingsState extends State<ProviderSettings> {
  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<MyProvider>(context); // Ensure MyProvider is available

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "settings".tr(),
          style: GoogleFonts.lora(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "language".tr(),
                style: GoogleFonts.lora(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    backgroundColor: Colors.white,
                    builder: (context) {
                      return LanguageBottomSheet(); // Ensure you create this widget
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Text(
                    context.locale == Locale("ar")
                        ? "arabic".tr()
                        : "english".tr(),
                    style: GoogleFonts.lora(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("aap-version".tr(),
                  style: GoogleFonts.lora(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  // provider.appTheme == ThemeMode.dark ? "dark".tr() :
                  "1.0.0",
                  style: GoogleFonts.lora(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
