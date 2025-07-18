import 'package:almoktar/screens/app/scanner.dart';
import 'package:flutter/material.dart';
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          const SizedBox(height: 16),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('صفحتي الشخصية'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),

          // ListTile(
          //   leading: const Icon(Icons.list_alt),
          //   title: const Text('طلباتي'),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) => const OrdersPage()),
          //     );
          //   },
          // ),

          ListTile(
            leading: const Icon(Icons.qr_code_scanner),
            title: const Text('امسح رمز QR'),
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
            title: const Text('تغيير اللغة'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ميزة قيد التطوير')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('تغيير كلمة المرور'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ميزة قيد التطوير')),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('تسجيل الخروج'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('تأكيد'),
                  content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        // ضع منطق تسجيل الخروج هنا
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('خروج'),
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

//
// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("SettingsScreen"),
//         backgroundColor: Theme.of(context).colorScheme.primary,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Text(
//               "Setting",
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onBackground,
//               ),
//             ),
//             ListTile(
//               leading: Icon(
//                 BlocProvider.of<ThemeCubit>(context).isDark
//                     ? Icons.dark_mode
//                     : Icons.light_mode,
//               ),
//               title: Text(
//                 'theme',
//                 style: Theme.of(context).textTheme.displayLarge,
//               ),
//               onTap: () {
//                 BlocProvider.of<ThemeCubit>(context).switchTheme();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }