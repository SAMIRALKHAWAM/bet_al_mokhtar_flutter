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
    extends State<ChefOrdersExpansionPanelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ChefOrderModel> getOrdersByStatus(String status) =>
      orders.where((order) => order.status == status).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text1: "طلبات الشيف",
          size: 22,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          tabs: const [
            Tab(text: "قيد الانتظار"),
            Tab(text: "قيد التجهيز"),
            Tab(text: "تم التجهيز"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList("pending", theme, primaryColor, onPrimary),
          _buildOrdersList("preparing", theme, primaryColor, onPrimary),
          _buildOrdersList("ready", theme, primaryColor, onPrimary),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
      String status,
      ThemeData theme,
      Color primaryColor,
      Color onPrimary,
      ) {
    final ordersByStatus = getOrdersByStatus(status);

    if (ordersByStatus.isEmpty) {
      return Center(
        child: CustomText(
          text1: "لا توجد طلبات",
          size: 16,
          color: theme.textTheme.bodyMedium?.color,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: ordersByStatus.length,
      itemBuilder: (context, index) {
        final order = ordersByStatus[index];
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
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
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
                const SizedBox(height: 12),
                if (order.status != "ready")
                  DefaultButton(
                    text: order.status == "pending" ? "ابدأ التجهيز" : "تم التجهيز",
                    onTap: () {
                      setState(() {
                        if (order.status == "pending") {
                          order.status = "preparing";
                        } else if (order.status == "preparing") {
                          order.status = "ready";
                        }
                      });
                    },
                    color: order.status == "pending" ? primaryColor : Colors.orange,
                    textColor: onPrimary,
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
      },
    );
  }
}
