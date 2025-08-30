import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth_cubit/cubit.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../models/get_internal_orders.dart';
import '../../models/get_order_delivery.dart';
import '../auth/login.dart';
import '../chief/OrderDetailsPage.dart';
import 'order_details.dart';

class DeliveryOrders extends StatefulWidget {
  const DeliveryOrders({super.key});

  @override
  State<DeliveryOrders> createState() => _DeliveryOrdersState();
}

class _DeliveryOrdersState extends State<DeliveryOrders>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final cubit = AppCubit.get(context);
    cubit.get_internal_orders_delivering();
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(

        leading: IconButton(
          icon: Icon(Icons.login_outlined),
          onPressed: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                title: Text('تأكيد تسجيل الخروج'),
                content: Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('إلغاء'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();

                      AuthCubit.get(context).Logout_emp();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                            (route) => false,
                      );
                    },
                    child: Text('تأكيد'),
                  ),
                ],
              ),
            );
          },
        ),
        title: const CustomText(
          text1: "طلبات التوصيل",
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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          tabs: const [
            Tab(text: "قيد التوصيل"),
            Tab(text: "تم التوصيل"),
          ],
        ),
      ),
      body: BlocBuilder<AppCubit, AppSates>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrdersList(cubit.orders_delivering_response?.data, "waiting"),
              _buildOrdersList(cubit.orders_delivering_response?.data, "preparing"),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderData>? orders, String status) {
    final theme = Theme.of(context);

    if (orders == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (orders.isEmpty) {
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
      itemCount: orders.length ,
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return InkWell(
            onTap: () {
              AppCubit.get(context).get_internal_order_items_For_D(id: order.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDeliveryDetailsPage(
                    orderId: order.id,
                    state: order.status,
                    type: order.type,
                    externalOrderInfo: order.externalOrderInfo, // ✅ نمرره
                  ),
                ),
              );

            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text1: "طلب رقم: ${order.id}",
                    size: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.titleLarge?.color,
                  ),
                  const SizedBox(height: 4),
                  CustomText(
                    text1: "العنوان: ${order.externalOrderInfo.location}",
                    size: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

