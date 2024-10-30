import 'package:flutter/material.dart';
import 'package:road_mate/bottom_sheets/theme_bottomsheet.dart';
import 'package:road_mate/theme/app-colors.dart';

class SettingsTab extends StatefulWidget {
  static const String routeName = "settings";
  SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  @override
  Widget build(BuildContext context) {
    // var provider = Provider.of<MyProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "theme",
              style: Theme.of(context).textTheme.headlineLarge,
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
                    return ThemeBottomSheet();
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Color(0xffB7935F)),
                ),
                child:
                    // provider.appTheme != ThemeMode.dark
                    //     ? Text(
                    //         "light".tr(),
                    //         style: Theme.of(context).textTheme.headlineMedium,
                    //       )
                    //     :
                    Text(
                  "dark",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              "language",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   isDismissible: true,
                //   backgroundColor: Colors.white,
                //   builder: (context) {
                //     return LanguageBottomSheet();
                //   },
                // );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.white),
                ),
                child:
                    // context.locale == Locale("ar")
                    //     ? Text(
                    //         "arabic".tr(),
                    //         style: Theme.of(context).textTheme.headlineMedium,
                    //       )
                    //     :
                    Text(
                  "english",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
