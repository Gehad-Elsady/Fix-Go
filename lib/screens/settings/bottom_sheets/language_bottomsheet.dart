import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:road_mate/theme/app-colors.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    // var provider = Provider.of<MyProvider>(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: AppColors.backGround,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "select-language".tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () {
              context.setLocale(Locale("en"));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "english".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentLocale == Locale('en')
                    ? Icon(
                        Icons.done,
                        size: 35,
                        color: Colors.white,
                      )
                    : SizedBox()
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              context.setLocale(Locale("ar"));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "arabic".tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentLocale != Locale('en')
                    ? Icon(
                        Icons.done,
                        size: 35,
                        color: Colors.white,
                      )
                    : SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
