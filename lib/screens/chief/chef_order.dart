import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../models/get_internal_orders.dart';
import 'OrderDetailsPage.dart';

class ChefOrdersExpansionPanelPage extends StatefulWidget {
  const ChefOrdersExpansionPanelPage({super.key});

  @override
  State<ChefOrdersExpansionPanelPage> createState() => _ChefOrdersExpansionPanelPageState();
}

class _ChefOrdersExpansionPanelPageState extends State<ChefOrdersExpansionPanelPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ScrollControllers منفصلين لكل تبويب
  final Map<String, ScrollController> scrollControllers = {
    "waiting": ScrollController(),
    "preparing": ScrollController(),
    "ready": ScrollController(),
  };

  // تعقب الصفحة الحالية لكل تبويب
  Map<String, int> currentPages = {
    "waiting": 1,
    "preparing": 1,
    "ready": 1,
  };

  // تعقب حالة التحميل لكل تبويب
  Map<String, bool> isLoadingMore = {
    "waiting": false,
    "preparing": false,
    "ready": false,
  };

  // تعقب وجود المزيد من البيانات لكل تبويب
  Map<String, bool> hasMoreData = {
    "waiting": true,
    "preparing": true,
    "ready": true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // إضافة مستمع لكل ScrollController للتحقق من النزول أسفل القائمة
    scrollControllers.forEach((status, controller) {
      controller.addListener(() => _scrollListener(status));
    });

    final cubit = AppCubit.get(context);

    // تحميل الصفحة الأولى من كل تبويب
    cubit.get_internal_orders_waiting(page: currentPages["waiting"]!);
    cubit.get_internal_orders_preparing(page: currentPages["preparing"]!);
    cubit.get_internal_orders_finshing(page: currentPages["ready"]!);
  }

  void _scrollListener(String status) {
    final controller = scrollControllers[status]!;

    if (controller.position.pixels >= controller.position.maxScrollExtent - 100 &&
        !isLoadingMore[status]! &&
        hasMoreData[status]!) {
      _loadMoreOrders(status);
    }
  }

  Future<void> _loadMoreOrders(String status) async {
    setState(() {
      isLoadingMore[status] = true;
      currentPages[status] = currentPages[status]! + 1;
    });

    final cubit = AppCubit.get(context);

    bool more = false;
    if (status == "waiting") {
      more = await cubit.get_internal_orders_waiting(page: currentPages[status]!);
    } else if (status == "preparing") {
      more = await cubit.get_internal_orders_preparing(page: currentPages[status]!);
    } else if (status == "ready") {
      more = await cubit.get_internal_orders_finshing(page: currentPages[status]!);
    }

    setState(() {
      hasMoreData[status] = more;
      isLoadingMore[status] = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollControllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
          tabs: const [
            Tab(text: "قيد الانتظار"),
            Tab(text: "قيد التجهيز"),
            Tab(text: "تم التجهيز"),
          ],
        ),
      ),
      body: BlocBuilder<AppCubit, AppSates>(
        builder: (context, state) {
          final cubit = AppCubit.get(context);

          return TabBarView(
            controller: _tabController,
            children: [
              _buildOrdersList(cubit.orders_waiting_response?.data, "waiting"),
              _buildOrdersList(cubit.orders_preparing_response?.data, "preparing"),
              _buildOrdersList(cubit.orders_finshing_response?.data, "ready"),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderItem>? orders, String status) {
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
      controller: scrollControllers[status],
      padding: const EdgeInsets.all(16),
      itemCount: orders.length + (hasMoreData[status]! ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < orders.length) {
          final order = orders[index];
          return InkWell(
            onTap: () {
              AppCubit.get(context).get_internal_order_items(id: order.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(
                    orderId: order.id,
                    state: order.status,
                    table_id: order.table_id,
                    type: order.type,
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
                    text1: order.type == "int" ? "  نوع الطلب : داخلي " : " نوع الطلب : خارجي ",
                    size: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ],
              ),
            ),
          );
        } else {
          // مؤشر تحميل البيانات الجديدة
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
