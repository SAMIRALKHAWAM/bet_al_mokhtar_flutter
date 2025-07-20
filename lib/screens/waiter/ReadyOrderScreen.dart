import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../components/colors.dart';

class ReadyOrdersScreen extends StatefulWidget {
  @override
  State<ReadyOrdersScreen> createState() => _ReadyOrdersScreenState();
}

class _ReadyOrdersScreenState extends State<ReadyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // جلب الطلبات الجاهزة عند بداية الشاشة
    AppCubit.get(context).get_internal_orders_finishing();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSates>(
      builder: (context, state) {
        return AppCubit.get(context).orders_finishing_response != null
            ? Scaffold(
          appBar: AppBar(
            title: Text("الطلبات الجاهزة", style: TextStyle(fontFamily: 'Tajawal')),
            centerTitle: true,
            backgroundColor: ColorApp.accent,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  AppCubit.get(context).get_internal_orders_finishing();
                },
              ),
            ],
          ),
          body: BlocBuilder<AppCubit, AppSates>(
            builder: (context, state) {
              final orders = AppCubit.get(context).orders_finishing_response!.data;

              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              }

              if (orders.isEmpty) {
                return Center(child: Text("لا يوجد طلبات جاهزة حالياً."));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    elevation: 4,
                    margin: EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      leading: Icon(Icons.restaurant_menu, color: ColorApp.accent, size: 30),
                      title: Text(
                        "طلب رقم ${order.id}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("رقم الطاولة: ${order.table_id ?? 'غير محددة'}"),
                    ),
                  );
                },
              );
            },
          ),
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
