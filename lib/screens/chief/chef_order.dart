
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/defaultButton.dart';
import '../../components/text.dart';
import 'OrderDetailsPage.dart';

class ChefOrderModel {
  final String orderId;
  final String customerName;
  final List<String> items;
  String status; // "pending", "preparing", "ready"

  ChefOrderModel({
    required this.orderId,
    required this.customerName,
    required this.items,
    this.status = "pending",
  });
}

class ChefOrdersExpansionPanelPage extends StatefulWidget {
  const ChefOrdersExpansionPanelPage({super.key});

  @override
  State<ChefOrdersExpansionPanelPage> createState() =>
      _ChefOrdersExpansionPanelPageState();
}

class _ChefOrdersExpansionPanelPageState
    extends State<ChefOrdersExpansionPanelPage> {
  List<ChefOrderModel> orders = [
    ChefOrderModel(
      orderId: "1001",
      customerName: "أحمد",
      items: ["بيتزا", "عصير برتقال"],
      status: "pending",
    ),
    ChefOrderModel(
      orderId: "1002",
      customerName: "ليلى",
      items: ["برجر دجاج", "بطاطا"],
      status: "pending",
    ),
    ChefOrderModel(
      orderId: "1003",
      customerName: "سارة",
      items: ["سلطة", "مياه"],
      status: "preparing",
    ),
    ChefOrderModel(
      orderId: "1091",
      customerName: "امجد",
      items: ["بيتزا", "عصير برتقال"],
      status: "ready",
    ),
    ChefOrderModel(
      orderId: "1302",
      customerName: "سميرة",
      items: ["برجر دجاج", "بطاطا"],
      status: "ready",
    ),
  ];

  // للحفاظ على حالة توسع الأقسام
  final Map<String, bool> _expanded = {
    "pending": true,
    "preparing": true,
    "ready": true,
  };

  List<ChefOrderModel> getOrdersByStatus(String status) =>
      orders.where((order) => order.status == status).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text1: "طلبات الشيف",
          size: 22,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              String key;
              if (index == 0)
                key = "pending";
              else if (index == 1)
                key = "preparing";
              else
                key = "ready";

              _expanded[key] = !isExpanded;
            });
          },
          children: [
            _buildPanel("قيد الانتظار", "pending", theme),
            _buildPanel("قيد التجهيز", "preparing", theme),
            _buildPanel("تم التجهيز", "ready", theme),
          ],
        ),
      ),
    );
  }

  ExpansionPanel _buildPanel(String title, String status, ThemeData theme) {
    final ordersByStatus = getOrdersByStatus(status);
    return ExpansionPanel(
      headerBuilder: (context, isExpanded) {
        return ListTile(
          title: CustomText(
            text1: "$title (${ordersByStatus.length})",
            size: 18,
            fontWeight: FontWeight.bold,
            color:
                status == "ready"
                    ? Colors.green
                    : status == "pending"
                    ? theme.colorScheme.primary
                    : Colors.orange,
          ),
        );
      },
      body:
          ordersByStatus.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomText(
                  text1: "لا توجد طلبات",
                  size: 14,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              )
              : Column(
                children:
                    ordersByStatus.map((order) {
                      return InkWell(
                        onTap: () {
                          if (order.status == "ready") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OrderDetailsPage(order: order),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text1: "طلب رقم: ${order.orderId}",
                                size: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.titleLarge?.color,
                              ),
                              const SizedBox(height: 4),
                              CustomText(
                                text1: "الزبون: ${order.customerName}",
                                size: 14,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                              const SizedBox(height: 4),
                              // CustomText(
                              //   text1: "العناصر: ${order.items.join(', ')}",
                              //   size: 14,
                              //   color: theme.textTheme.bodyMedium?.color,
                              // ),
                              const SizedBox(height: 12),
                              if (order.status != "ready")
                                DefaultButton(
                                  text:
                                      order.status == "pending"
                                          ? "ابدأ التجهيز"
                                          : "تم التجهيز",
                                  onTap: () {
                                    setState(() {
                                      if (order.status == "pending") {
                                        order.status = "preparing";
                                      } else if (order.status == "preparing") {
                                        order.status = "ready";
                                      }
                                    });
                                  },
                                  color:
                                      order.status == "pending"
                                          ? theme.colorScheme.primary
                                          : Colors.orange,
                                  textColor: theme.colorScheme.onPrimary,
                                  width: double.infinity,
                                  height: 45,
                                  borderRadius: 12,
                                  size: 14,
                                )
                              else
                                CustomText(
                                  text1: "✔ تم تجهيز الطلب",
                                  size: 14,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
      isExpanded: _expanded[status] ?? false,
    );
  }
}
