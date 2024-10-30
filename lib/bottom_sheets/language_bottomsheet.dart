// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:islami_app/providers/my_provider.dart';
// import 'package:islami_app/theme/app-colors.dart';
// import 'package:provider/provider.dart';

// class LanguageBottomSheet extends StatelessWidget {
//   const LanguageBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Locale currentLocale = context.locale;
//     var provider = Provider.of<MyProvider>(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: provider.appTheme == ThemeMode.dark
//             ? AppColor.DarchPraimaryColor
//             : Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       padding: EdgeInsets.all(18),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "select_language".tr(),
//             style: Theme.of(context)
//                 .textTheme
//                 .headlineLarge
//                 ?.copyWith(color: AppColor.PraimaryColor),
//           ),
//           SizedBox(
//             height: 40,
//           ),
//           InkWell(
//             onTap: () {
//               context.setLocale(Locale("en"));
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "english".tr(),
//                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       color: currentLocale == Locale('en')
//                           ? AppColor.PraimaryColor
//                           : AppColor.BlackColor),
//                 ),
//                 currentLocale == Locale('en')
//                     ? Icon(
//                         Icons.done,
//                         size: 35,
//                       )
//                     : SizedBox()
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 24,
//           ),
//           InkWell(
//             onTap: () {
//               context.setLocale(Locale("ar"));
//             },
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("arabic".tr(),
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: currentLocale != Locale('en')
//                             ? AppColor.PraimaryColor
//                             : AppColor.BlackColor)),
//                 currentLocale != Locale('en')
//                     ? Icon(
//                         Icons.done,
//                         size: 35,
//                       )
//                     : SizedBox()
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
