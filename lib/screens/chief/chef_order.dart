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
  late ScrollController _scrollController;

  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(_scrollListener);

    final cubit = AppCubit.get(context);
    cubit.get_internal_orders_waiting(page: _currentPage);
    cubit.get_internal_orders_preparing();
    cubit.get_internal_orders_pending();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        _hasMoreData &&
        _tabController.index == 0) {
      _loadMoreOrders();
    }
  }

  Future<void> _loadMoreOrders() async {
    _isLoadingMore = true;
    _currentPage++;
    final hasMore = await AppCubit.get(context).get_internal_orders_waiting(page: _currentPage);
    _hasMoreData = hasMore;
    _isLoadingMore = false;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
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
              _buildOrdersList(cubit.orders_pending_response?.data, "ready"),
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
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: orders.length + (_hasMoreData ? 1 : 0),
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
                    text1:
                    order.type=="int"?
                    " نوع الطلب : داخلي ":" نوع الطلب : خارجي ",
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

