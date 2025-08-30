import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:svg_flutter/svg.dart';

import '../../blocs/cubit_app/cubit.dart';
import '../../blocs/cubit_app/statues.dart';
import '../../models/get_internal_order_items.dart';
import '../../models/get_order_delivery.dart';
import '../../network/end_point.dart';
import 'delivery_order.dart';

class OrderDeliveryDetailsPage extends StatefulWidget {
  final int orderId;
  final String state;
  final String type;
  final ExternalOrderInfo? externalOrderInfo;

  const OrderDeliveryDetailsPage({
    Key? key,
    required this.orderId,
    required this.state,
    required this.type,
    this.externalOrderInfo,
  }) : super(key: key);

  @override
  State<OrderDeliveryDetailsPage> createState() => _OrderDeliveryDetailsPageState();
}

class _OrderDeliveryDetailsPageState extends State<OrderDeliveryDetailsPage> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).get_internal_order_items(id: widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = AppCubit.get(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          AppCubit.get(context).get_internal_orders_delivering();


          Navigator.push(context, MaterialPageRoute(builder: (context)=>DeliveryOrders()));


        }, icon: Icon(Icons.arrow_back)),

        title: Text('تفاصيل الطلب ${widget.orderId}'),
        centerTitle: true,
      ),
      body: BlocBuilder<AppCubit, AppSates>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is get_internal_order_itemsErrorState || cubit.internalorderResponse_D == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 40),
                  const SizedBox(height: 10),
                  const Text('فشل في تحميل بيانات الطلب'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => cubit.get_internal_order_items(id: widget.orderId),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          final orderDetails = cubit.internalorderResponse_D!;
          print("${url_photo}${widget.externalOrderInfo!.qr}");

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildCard(
                  title: 'معلومات الطلب',
                  children: [
                    _buildKeyValue('رقم الطلب', widget.orderId.toString()),
                    _buildKeyValue('الحالة', widget.state=="delivering"?"التوصيل":"تم التوصيل "),
                    _buildKeyValue('نوع الطلب', widget.type == "int" ? "   داخلي " : "  خارجي ",),
                    if (widget.type == 'ext' && widget.externalOrderInfo != null) ...[
                      _buildKeyValue('العنوان', widget.externalOrderInfo!.location),
                      _buildKeyValue('رقم الهاتف', widget.externalOrderInfo!.phone),
                    ],
                  ],
                ),

                if (widget.type == 'ext' && widget.externalOrderInfo?.qr != null)

                  _buildCard(
                    title: 'رمز QR',
                    children: [
                      Center(
                        child: SvgPicture.network(
                          "${url_photo}${widget.externalOrderInfo!.qr}",
                          height: 200,
                          placeholderBuilder: (_) => const CircularProgressIndicator(),
                          semanticsLabel: 'QR Code',
                        ),
                      ),
                    ],
                  ),

                _buildCard(
                  title: 'العناصر',
                  children: orderDetails.data.items
                      .map((item) => ListTile(
                    title: Text(item.itemName),
                    subtitle: Text('الكمية: ${item.quantity}'),
                    trailing: Text('${item.itemPrice} ل.س'),
                  ))
                      .toList(),
                ),

                _buildCard(
                  title: 'العروض',
                  children: orderDetails.data.offers
                      .map((offerItem) => ExpansionTile(
                    title: Text(offerItem.offer.name),
                    subtitle: Text('الكمية: ${offerItem.quantity} - السعر: ${offerItem.price}'),
                    children: offerItem.offer.offerItems
                        .map((itemDetail) => ListTile(
                      title: Text(itemDetail.item.name),
                      subtitle: Text('الكمية: ${itemDetail.quantity} - السعر: ${itemDetail.price}'),
                    ))
                        .toList(),
                  ))
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildKeyValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('$label:', style: const TextStyle(color: Colors.grey))),
          Expanded(flex: 3, child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
