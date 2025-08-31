import 'package:almoktar/screens/app/print.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/models/get_invoice.dart';


class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).get_invoices_User();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final cubit = AppCubit.get(context);
        if (cubit.hasMoreInvoices && !cubit.isInvoiceLoading) {
          cubit.get_invoices_User(page: cubit.currentInvoicePage + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildInvoiceItem(Invoice invoice) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InvoiceDetailsWidget(invoiceId: invoice.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("رقم الفاتورة: ${invoice.id}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Text("الفرع: ${invoice.branchName}", style: const TextStyle(fontSize: 14)),
              Text("السعر الكلي: ${invoice.fullPrice}  ل.س", style: const TextStyle(fontSize: 14)),
              Text("الضريبة: ${invoice.tax}  ل.س", style: const TextStyle(fontSize: 14)),
              Text("الخصم: ${invoice.discount} ل.س", style: const TextStyle(fontSize: 14)),
              Text("السعر النهائي: ${invoice.finalPrice} ل.س", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Chip(
                    label: Text(invoice.status == "done" ? "تم التسليم" : invoice.status),
                    backgroundColor: invoice.status == "done" ? Colors.green[100] : Colors.grey[300],
                    labelStyle: TextStyle(
                      color: invoice.status == "done" ? Colors.green[800] : Colors.black,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        final invoices = cubit.Get_InvoiceResponse?.data ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text("الفواتير"),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: state is get_invoiceErrorState
                    ? const Center(child: Text("حدث خطأ أثناء تحميل الفواتير"))
                    : invoices.isEmpty && state is LoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                  controller: _scrollController,
                  itemCount: invoices.length + (cubit.hasMoreInvoices ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < invoices.length) {
                      return buildInvoiceItem(invoices[index]);
                    } else {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
