import 'package:almoktar/screens/app/OrderConfirmedPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/textfromfilde.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final couponController = TextEditingController();
  String deliveryMethod = 'Delivery';

  // مثال لقائمة الطلبات المختارة
  final List<Map<String, dynamic>> cartItems = [
    {'name': 'Burger', 'price': 20.0, 'quantity': 1},
    {'name': 'Pizza', 'price': 35.0, 'quantity': 2},
  ];

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item['price'] * item['quantity']);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text("Your Cart", style: theme.textTheme.titleLarge),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cartItems.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: const Icon(Icons.fastfood),
                        title: Text(item['name']),
                        subtitle: Text("Qty: ${item['quantity']}"),
                        trailing: Text(
                          "${item['price'] * item['quantity']} \$",
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),

                // اختيار طريقة التوصيل
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'Delivery',
                        groupValue: deliveryMethod,
                        title: const Text('Delivery'),
                        onChanged: (value) {
                          setState(() => deliveryMethod = value!);
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        value: 'Pickup',
                        groupValue: deliveryMethod,
                        title: const Text('Pickup'),
                        onChanged: (value) {
                          setState(() => deliveryMethod = value!);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // كوبون خصم
                CustomTextFormField(
                  controller: couponController,
                  hint: "Discount Code",
                  color: theme.colorScheme.onSecondaryFixed,
                  radius: 15,
                ),

                const SizedBox(height: 20),

                // السعر النهائي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total", style: theme.textTheme.titleMedium),
                    Text(
                      "${totalPrice.toStringAsFixed(2)} \$",
                      style: theme.textTheme.titleMedium,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // زر إتمام الطلب
                DefaultButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OrderConfirmedPage()),
                    );
                    // تنفيذ الطلب

                    print("Order submitted");
                  },
                  text: 'Confirm Order',
                  color: theme.colorScheme.primary,
                  textColor: theme.colorScheme.onPrimary,
                  size: 18,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
