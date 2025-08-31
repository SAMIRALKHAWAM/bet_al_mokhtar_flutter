import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import 'TableBookingPage.dart';
import 'scanner.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _showRatingBottomSheet(BuildContext context) {
    double rating = 0;
    TextEditingController noteController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "rate_order".tr(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text("choose_stars".tr()),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 32,
                          ),
                          onPressed: () {
                            setState(() => rating = index + 1.0);
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "notes_optional".tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (rating == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("please_rate_first".tr())),
                          );
                          return;
                        }

                        print("⭐ Rating: $rating");
                        print("📝 Notes: ${noteController.text}");

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "submit_rating".tr(),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit, AppSates>(
      listener: (context, state) {
        if (state is accept_external_orderSuccessState) {
          // تحقق أن الصفحة الظاهرة هي SettingsPage
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            print('✅ SettingsPage is current and state is success');
            _showRatingBottomSheet(context);
          }
        }
      },
      child: Scaffold(
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
              title: Text('change_language'.tr()),
              onTap: () async {
                final current = context.locale.languageCode;
                final newLocale = current == 'ar' ? const Locale('en') : const Locale('ar');
                await context.setLocale(newLocale);
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
              title: Text('book_table'.tr()),
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
                          Navigator.pop(context);
                          Navigator.pop(context);
                          // ضع منطق تسجيل الخروج هنا
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
      ),
    );
  }
}
