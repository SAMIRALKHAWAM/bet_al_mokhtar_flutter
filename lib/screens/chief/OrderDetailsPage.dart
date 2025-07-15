import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  final String state;
  final dynamic table_id;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
    required this.state,
    required this.table_id,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AppCubit, AppSates>(
      listener: (context, state) {
        if (state is orderchangeSuccessState) {
          final cubit = AppCubit.get(context);
          cubit.get_internal_orders_pending();
          cubit.get_internal_orders_preparing();
          cubit.get_internal_orders_waiting();
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<AppCubit, AppSates>(
        builder: (context, state) {
          final internalOrder = AppCubit.get(context).internalorderResponse?.data;

          if (state is LoadingState || internalOrder == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text('تفاصيل الطلب رقم ${widget.orderId}'),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text(
                    "المحتويات",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // الأصناف
                  Text(
                    "🧾 الأصناف المطلوبة",
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Divider(thickness: 1),
                  ...internalOrder.items.map(
                        (item) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      leading: const Icon(Icons.restaurant_menu, color: Colors.teal),
                      title: Text(item.itemName),
                      trailing: Text(
                        "× ${item.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // العروض
                  if (internalOrder.offers.isNotEmpty) ...[
                    Text(
                      "🎁 العروض",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const Divider(thickness: 1),
                    ...internalOrder.offers.map(
                          (orderOffer) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            leading: const Icon(Icons.local_offer, color: Colors.deepOrange),
                            title: Text(orderOffer.offer.name),
                            trailing: Text(
                              "× ${orderOffer.quantity}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 32, bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: orderOffer.offer.offerItems.map((offerItem) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.arrow_right, size: 18, color: Colors.grey),
                                      Text(
                                        "${offerItem.item.name} (x${offerItem.quantity})",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // زر تغيير حالة الطلب حسب الحالة الحالية
            bottomNavigationBar: _buildStatusButton(widget.state),
          );
        },
      ),
    );
  }

  Widget? _buildStatusButton(String status) {
    String buttonText = '';
    Color buttonColor = Colors.teal;
    String nextStatus = '';

    if (status == 'waiting') {
      buttonText = 'ابدأ التجهيز';
      buttonColor = Colors.orange;
      nextStatus = 'preparing';
    } else if (status == 'preparing') {
      buttonText = 'تم التجهيز';
      buttonColor = Colors.green;
      nextStatus = 'finishing';
    } else {
      return null; // لا زر إذا كانت الحالة "ready"
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          AppCubit.get(context).change_internal_order_status(
            table_id: widget.table_id,
            status: nextStatus,
            order_id: widget.orderId,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
