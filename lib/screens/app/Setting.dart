import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../models/get_branch.dart';
import 'TableBookingPage.dart';
import 'invoice_user.dart';
import 'scanner.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // تحميل الفروع مرة واحدة عند بداية الصفحة
    AppCubit.get(context).Branch();
  }

  void _showRatingBottomSheet(BuildContext context) {
    double rating = 0;
    BranchModel? selectedBranch;
    TextEditingController noteController = TextEditingController();
    final branches = AppCubit.get(context).branch_model?.data ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return BlocConsumer<AppCubit, AppSates>(
          listener: (context, state) {
            if (state is rate_SuccessState) {
              Navigator.pop(context); // إغلاق الـ BottomSheet عند النجاح
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('تم التقييم بنجاح')),
              );
            } else if (state is rate_ErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('حدث خطأ أثناء إرسال التقييم')),
              );
            }
          },
          builder: (context, state) {
            bool isLoading = state is LoadingState;

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

                        DropdownButtonFormField<BranchModel>(
                          value: selectedBranch,
                          items: branches.map((branch) {
                            return DropdownMenuItem(
                              value: branch,
                              child: Text(branch.name),
                            );
                          }).toList(),
                          onChanged: isLoading ? null : (branch) {
                            setState(() => selectedBranch = branch);
                          },
                          decoration: InputDecoration(
                            labelText: "اختر الفرع",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                              onPressed: isLoading ? null : () {
                                setState(() => rating = index + 1.0);
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: noteController,
                          maxLines: 3,
                          enabled: !isLoading,
                          decoration: InputDecoration(
                            labelText: "notes_optional".tr(),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            if (rating == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("please_rate_first".tr())),
                              );
                              return;
                            }

                            if (selectedBranch == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("يرجى اختيار الفرع")),
                              );
                              return;
                            }

                            AppCubit.get(context).create_rate(
                              rate: rating.toInt(),
                              description: noteController.text,
                              branch_id: selectedBranch!.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            "submit_rating".tr(),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),

                        const SizedBox(height: 12),

                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "skip".tr(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
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
      },
    );
  }

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
              // افتح صفحة الملف الشخصي
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
            leading: const Icon(Icons.receipt_long),
            title: Text('عرض الفواتير'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => InvoicesScreen()),
              );
            },
          ),

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
            leading: const Icon(Icons.star),
            title: Text('rate_order'.tr()),
            onTap: () {
              _showRatingBottomSheet(context);
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
                        // هنا ضع منطق تسجيل الخروج إذا موجود
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
