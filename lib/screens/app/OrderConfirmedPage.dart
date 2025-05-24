import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/components/defaultButton.dart';

class OrderConfirmedPage extends StatelessWidget {
  const OrderConfirmedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ أيقونة التأكيد
                  Icon(Icons.verified, size: 100, color: theme.colorScheme.primary),

                  const SizedBox(height: 20),

                  // ✅ النص العلوي
                  Text(
                    "Order Confirmed",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // ✅ النص الثانوي
                  Text(
                    "Looking for driver...",
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 30),

                  // ✅ أيقونة البحث عن سائق (عدّلتها لتتناسب مع Flutter)
                  Icon(Icons.search, size: 60, color: theme.colorScheme.primary),

                  const SizedBox(height: 40),

                  // ✅ زر المساعدة
                  DefaultButton(
                    onTap: () {
                      // إضافة منطق المساعدة هنا
                      print("Need Help tapped");
                    },
                    text: 'Need Help?',
                    color: Colors.grey[200]!,
                    textColor: Colors.black,
                    size: 16,
                    width: double.infinity,
                  ),

                  const SizedBox(height: 15),

                  // ✅ زر الإلغاء
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
