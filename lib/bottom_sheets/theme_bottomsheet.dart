import 'package:flutter/material.dart';
import 'package:road_mate/theme/app-colors.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            //  provider.appTheme == ThemeMode.dark
            //     ? AppColor.DarchPraimaryColor
            //     :
            Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "select_theme",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: AppColors.white),
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                // provider.changeTheme(ThemeMode.light);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "light",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // provider.appTheme == ThemeMode.dark
                  //     ? SizedBox()
                  //     :
                  Icon(
                    Icons.done,
                    size: 35,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                // provider.changeTheme(ThemeMode.dark);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "dark",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  // provider.appTheme == ThemeMode.light
                  //     ? SizedBox()
                  //     :
                  Icon(
                    Icons.done,
                    size: 35,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
