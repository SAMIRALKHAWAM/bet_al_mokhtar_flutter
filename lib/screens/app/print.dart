import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/cubit.dart';
import '../../models/print_invoice.dart';
 // عدّل إذا عندك ملفات حالات منفصلة

  class InvoiceDetailsWidget extends StatefulWidget {
  final dynamic invoiceId;

   InvoiceDetailsWidget({Key? key, required this.invoiceId}) : super(key: key);

  @override
  State<InvoiceDetailsWidget> createState() => _InvoiceDetailsWidgetState();
}

class _InvoiceDetailsWidgetState extends State<InvoiceDetailsWidget> {
  @override
  void initState() {
    super.initState();
    // استدعاء الدالة من Cubit عند الدخول للواجهة
    AppCubit.get(context).print_invoice(id: widget.invoiceId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppSates>(
      builder: (context, state) {
        final cubit = AppCubit.get(context);

        if (state is LoadingState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is get_invoiceErrorState) {
          return Scaffold(
            appBar: AppBar(title: const Text("تفاصيل الفاتورة")),
            body: const Center(child: Text("حدث خطأ أثناء تحميل الفاتورة")),
          );
        }

        final invoiceData = cubit.print_invoice_response;

        if (invoiceData == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("تفاصيل الفاتورة")),
            body: const Center(child: Text("لا توجد بيانات")),
          );
        }

        final invoice = invoiceData.data.invoice;
        final items = invoiceData.data.items;
        final taxes = invoiceData.data.taxes;
        final discounts = invoiceData.data.discounts;
        final offers = invoiceData.data.offers;

        return Scaffold(
          appBar: AppBar(title: const Text("تفاصيل الفاتورة")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('فاتورة رقم: ${invoice.id}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('فرع: ${invoice.branchName}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),

                const Text('العناصر:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...items.map((item) => ListTile(
                  title: Text(item.name),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('الكمية: ${item.quantity}'),
                      Text('السعر: ${item.price}'),
                      Text('الإجمالي: ${item.totalPrice}'),
                    ],
                  ),
                )),
                const Divider(height: 32),
                //
                // if (taxes.isNotEmpty) ...[
                //   const Text('الضرائب:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                //   ...taxes.map((tax) => ListTile(
                //     title: Text(tax.taxName),
                //     trailing: Text('${tax.percent}% - ${tax.amount}'),
                //   )),
                //   const Divider(height: 32),
                // ],

                if (discounts.isNotEmpty) ...[
                  const Text('الخصومات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...discounts.map((discount) => ListTile(
                    title: Text('خصم'), // عدّل إذا صار في بيانات خصم
                  )),
                  const Divider(height: 32),
                ],

                if (offers.isNotEmpty) ...[
                  const Text('العروض:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ...offers.map((offer) => ListTile(
                    title: Text('عرض'), // عدّل إذا صار في بيانات عرض
                  )),
                  const Divider(height: 32),
                ],

                Text('السعر الكامل: ${invoice.fullPrice}', style: const TextStyle(fontSize: 16)),
                Text('الضريبة: ${invoice.tax}', style: const TextStyle(fontSize: 16)),
                Text('الخصم: ${invoice.discount}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('السعر النهائي: ${invoice.finalPrice}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),

                ],
            ),
          ),
        );
      },
    );
  }
}
