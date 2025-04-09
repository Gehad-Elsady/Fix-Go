import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:road_mate/theme/app-colors.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    // var provider = Provider.of<MyProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Color(0xffADE1FB),
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
            style: GoogleFonts.lora(
              color: Colors.black,
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
                  style: GoogleFonts.lora(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentLocale == Locale('en')
                    ? Icon(
                        Icons.done,
                        size: 35,
                        color: Color(0xff01082D),
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
                  style: GoogleFonts.lora(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                currentLocale != Locale('en')
                    ? Icon(
                        Icons.done,
                        size: 35,
                        color: Color(0xff01082D),
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
