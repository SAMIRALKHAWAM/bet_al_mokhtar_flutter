// import 'package:almoktar/screens/app/scanner.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الإعدادات'),
//         centerTitle: true,
//       ),
//       body: ListView(
//         children: [

//           const SizedBox(height: 16),

//           ListTile(
//             leading: const Icon(Icons.person),
//             title: const Text('صفحتي الشخصية'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const SettingsPage()),
//               );
//             },
//           ),

//           // ListTile(
//           //   leading: const Icon(Icons.list_alt),
//           //   title: const Text('طلباتي'),
//           //   onTap: () {
//           //     Navigator.push(
//           //       context,
//           //       MaterialPageRoute(builder: (_) => const OrdersPage()),
//           //     );
//           //   },
//           // ),

//           ListTile(
//             leading: const Icon(Icons.qr_code_scanner),
//             title: const Text('امسح رمز QR'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (_) => const ScanQrPage()),
//               );
//             },
//           ),

//           const Divider(),

// ListTile(
//             leading: Icon(Icons.language),
//             title: Text(
//               "Change Language".tr(),
//               style: Theme.of(context).textTheme.displayLarge,
//             ),
//             onTap: () async {
//               if (context.locale.languageCode == 'ar') {
//                 await context.setLocale(const Locale('en'));
//               } else {
//                 await context.setLocale(const Locale('ar'));
//               }
//             }),
//           ListTile(
//             leading: const Icon(Icons.language),
//             title: const Text('تغيير اللغة'),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('ميزة قيد التطوير')),
//               );
//             },
//           ),

//           ListTile(
//             leading: const Icon(Icons.lock),
//             title: const Text('تغيير كلمة المرور'),
//             onTap: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(content: Text('ميزة قيد التطوير')),
//               );
//             },
//           ),

//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: const Text('تسجيل الخروج'),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (_) => AlertDialog(
//                   title: const Text('تأكيد'),
//                   content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('إلغاء'),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         // ضع منطق تسجيل الخروج هنا
//                         Navigator.pop(context);
//                         Navigator.pop(context);
//                       },
//                       child: const Text('خروج'),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),

//         ],
//       ),
//     );
//   }
// }

// //
// // class SettingsScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("SettingsScreen"),
// //         backgroundColor: Theme.of(context).colorScheme.primary,
// //       ),
// //       body: Center(
// //         child: Column(
// //           children: [
// //             Text(
// //               "Setting",
// //               style: TextStyle(
// //                 color: Theme.of(context).colorScheme.onBackground,
// //               ),
// //             ),
// //             ListTile(
// //               leading: Icon(
// //                 BlocProvider.of<ThemeCubit>(context).isDark
// //                     ? Icons.dark_mode
// //                     : Icons.light_mode,
// //               ),
// //               title: Text(
// //                 'theme',
// //                 style: Theme.of(context).textTheme.displayLarge,
// //               ),
// //               onTap: () {
// //                 BlocProvider.of<ThemeCubit>(context).switchTheme();
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }




import 'package:almoktar/screens/app/scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'TableBookingPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.person),
            title: Text('my_profile'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),

          // إذا أردت تفعيل الطلبات لاحقاً
          // ListTile(
          //   leading: const Icon(Icons.list_alt),
          //   title: Text('my_orders'.tr()),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const OrdersPage()),
          //     );
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: Text('scan_qr'.tr()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanQrPage()),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title: Text(
              'change_language'.tr(),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: () async {
              if (context.locale.languageCode == 'ar') {
                await context.setLocale(const Locale('en'));
              } else {
                await context.setLocale(const Locale('ar'));
              }
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: Text('change_password'.tr()),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('feature_in_progress'.tr())),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.restaurant),
            title: Text('book_table'.tr()), // تأكد أنك أضفت هذا المفتاح في ملفات الترجمة
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TableBookingPage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.tr()),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('confirm'.tr()),
                  content: Text('logout_confirm'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('cancel'.tr()),
                    ),
                    TextButton(
                      onPressed: () {
                        // هنا ضع منطق تسجيل الخروج
                        Navigator.pop(context); // إغلاق AlertDialog
                        Navigator.pop(context); // رجوع للصفحة السابقة
                      },
                      child: Text('exit'.tr()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
