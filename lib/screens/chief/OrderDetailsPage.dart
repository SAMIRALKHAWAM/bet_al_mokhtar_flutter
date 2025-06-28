

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/defaultButton.dart';
import '../../components/text.dart';
import 'OrderDetailsPage.dart';
import 'chef_order.dart';

class OrderDetailsPage extends StatelessWidget {
  final ChefOrderModel order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الطلب رقم ${order.orderId}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text1: "طلب رقم: ${order.orderId}",
              size: 16,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleLarge?.color,
            ),

            Text(
              "الزبون: ${order.customerName}",
              style: theme.textTheme.titleLarge,
            ),

            SizedBox(height: 12),

            Text("العناصر:", style: theme.textTheme.titleLarge),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text("- $item", style: theme.textTheme.bodyMedium),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "حالة الطلب: ${order.status == "ready" ? "تم التجهيز" : order.status}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: order.status == "ready" ? Colors.green : Colors.orange,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
