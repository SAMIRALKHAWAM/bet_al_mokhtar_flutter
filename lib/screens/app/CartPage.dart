import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/components/defaultButton.dart';
import 'package:easy_localization/easy_localization.dart';

import 'NextSteps.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSates>(
      builder: (context, appState) {
        final cubit = AppCubit.get(context);
        final orderItems = cubit.orderItems;
        final orderOffers = cubit.orderOffers;

        final totalPrice = [
          ...orderItems.map((e) => e.price * e.quantity),
          ...orderOffers.map((e) => e.price * e.quantity),
        ].fold(0.0, (sum, item) => sum + item);

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final theme = Theme.of(context);

            return Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    Text("cart_title".tr()),
                    if (orderItems.isNotEmpty || orderOffers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${orderItems.length + orderOffers.length}',
                            style: const TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 0.5,
              ),
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: (orderItems.isEmpty && orderOffers.isEmpty)
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_cart_outlined,
                                size: 80,
                                color: theme.colorScheme.secondary.withOpacity(0.4)),
                            const SizedBox(height: 20),
                            Text(
                              "cart_empty".tr(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                          : ListView.separated(
                        itemCount: orderItems.length + orderOffers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          if (index < orderItems.length) {
                            final item = orderItems[index];
                            return _buildCartItem(
                              theme,
                              name: item.name,
                              quantity: item.quantity,
                              total: item.price * item.quantity,
                              isOffer: false,
                              id: item.id,
                              context: context,
                            );
                          } else {
                            final offer = orderOffers[index - orderItems.length];
                            return _buildCartItem(
                              theme,
                              name: offer.name,
                              quantity: offer.quantity,
                              total: offer.price * offer.quantity,
                              isOffer: true,
                              id: offer.id,
                              context: context,
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  if (orderItems.isNotEmpty || orderOffers.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, -2),
                          )
                        ],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.wallet, color: theme.colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text("total_label".tr(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Text(
                                  "${totalPrice.toStringAsFixed(2)} \$",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 24, thickness: 1),
                            DefaultButton(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>  OrderNextStep()),
                                );
                              },
                              text: "confirm_order".tr(),
                              color: theme.colorScheme.primary,
                              textColor: theme.colorScheme.onPrimary,
                              size: 18,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCartItem(
      ThemeData theme, {
        required String name,
        required int quantity,
        required num total,
        required bool isOffer,
        required int id,
        required BuildContext context,
      }) {
    final cubit = AppCubit.get(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isOffer
                    ? [Colors.green.shade100, Colors.green.shade50]
                    : [Colors.orange.shade100, Colors.orange.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                )
              ],
            ),
            child: Icon(
              isOffer ? Icons.local_offer : Icons.fastfood,
              color: isOffer ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${"quantity".tr()}: $quantity",
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            cubit.decreaseItemQuantity(id, isOffer);
                          },
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.increaseItemQuantity(id, isOffer);
                          },
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.green),
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            "${total.toStringAsFixed(2)} \$",
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
