import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../models/get_deliveryman.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  final String state;
  final dynamic table_id;
  final dynamic type;

  const OrderDetailsPage({
    super.key,
    required this.orderId,
    required this.state,
    required this.table_id,
    required this.type,
  });

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  List<DeliveryMan> deliveryMen = [];
  DeliveryMan? selectedDeliveryMan;
  bool isLoadingDeliveryMen = false;

  @override
  void initState() {
    super.initState();
    if (widget.type == "ext") {
      _loadDeliveryMen();
    }
  }

  Future<void> _loadDeliveryMen() async {
    setState(() => isLoadingDeliveryMen = true);

     await AppCubit.get(context).Delivery_Man();

    final cubit = AppCubit.get(context);
    setState(() {
      deliveryMen = List<DeliveryMan>.from(cubit.deliveryman_model?.data ?? []);
      isLoadingDeliveryMen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AppCubit, AppSates>(
      listener: (context, state) {
        if (state is orderchangeSuccessState) {
          final cubit = AppCubit.get(context);
          cubit.get_internal_orders_finshing();
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

            // actions: [
            //   IconButton(onPressed: (){
            //
            //
            //
            //   }, icon:Icon(Icons.arrow_back_rounded))
            //
            // ],
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
      return null;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {




          if (widget.type == "ext" && status == 'preparing') {
            if (isLoadingDeliveryMen) {
              showDialog(
                context: context,
                builder: (_) => const Center(child: CircularProgressIndicator()),
                barrierDismissible: false,
              );
              await _loadDeliveryMen();
              if (context.mounted) Navigator.pop(context);
            }

            if (context.mounted) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => StatefulBuilder(
                  builder: (context, setModalState) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("اختر موظف التوصيل", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          if (deliveryMen.isEmpty)
                            const Text("لا يوجد موظفين توصيل متاحين حالياً"),
                          if (deliveryMen.isNotEmpty)
                            DropdownButton<DeliveryMan>(
                              value: selectedDeliveryMan,
                              isExpanded: true,
                              hint: const Text("اختر دليفري"),
                              items: deliveryMen.map((dm) {
                                return DropdownMenuItem(
                                  value: dm,
                                  child: Text(dm.name?.toString() ?? "بدون اسم"),
                                );
                              }).toList(),
                              onChanged: (dm) {
                                setModalState(() => selectedDeliveryMan = dm);
                              },
                            ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: selectedDeliveryMan == null
                                ? null
                                : () {
                              Navigator.pop(context);
                              AppCubit.get(context).change_external_order_status(
                                delivery_man_id: selectedDeliveryMan!.id,
                                status: "delivering",
                                order_id: widget.orderId,
                              );
                            },
                            child: const Text("تأكيد"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            if(widget.type!="ext") {
              AppCubit.get(context).change_internal_order_status(
                table_id: widget.table_id,
                status: nextStatus,
                order_id: widget.orderId,
              );
            }
            else {
              AppCubit.get(context).change_ext_order_status(
                status: nextStatus,
                order_id: widget.orderId,
              );
            }
          }
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
