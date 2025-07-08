import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/cubit_app/statues.dart';
import 'emp.dart';

class ResponsiveTablesScreen extends StatefulWidget {
  @override
  State<ResponsiveTablesScreen> createState() => _ResponsiveTablesScreenState();
}

class _ResponsiveTablesScreenState extends State<ResponsiveTablesScreen> {
  @override
  void initState() {
    super.initState();

    AppCubit.get(context).Table_get();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('الطاولات', style: TextStyle(fontFamily: 'Tajawal')),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => AppCubit.get(context).Table_get(),
              )
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Expanded(
                    child: BlocBuilder<AppCubit, AppSates>(
                      builder: (context, state) {
                        if (state is LoadingState) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is tableSuccessState) {
                          final tables = AppCubit.get(context).Table_model?.data ?? [];
                          if (tables.isEmpty) {
                            return Center(
                              child: Text('لا توجد طاولات متاحة',
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              itemCount: tables.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isTablet ? 4 : 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: isTablet ? 1 : 0.95, // زدت شوية الارتفاع هنا
                              ),
                              itemBuilder: (context, index) {
                                final table = tables[index];
                                return Material(
                                  elevation: 6,
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      if (table.available) {
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text('فتح الطاولة'),
                                            content: Text('هل تريد اشغال الطاولة رقم ${table.tableNumber}?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: Text('إلغاء'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  AppCubit.get(context)
                                                      .table_change_statu(table_id: table.id);
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          WaiterOrderInterface(table.id, table.tableNumber, table.invoice_id),
                                                    ),
                                                  );
                                                },
                                                child: Text('فتح'),
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                WaiterOrderInterface(table.id, table.tableNumber, table.invoice_id),
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        gradient: LinearGradient(
                                          colors: table.available
                                              ? [Colors.green.shade400, Colors.green.shade700]
                                              : [Colors.red.shade400, Colors.red.shade700],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(12),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min, // مهم جدا لمنع overflow
                                        children: [
                                          Icon(
                                            table.available ? Icons.event_available : Icons.restaurant_menu,
                                            size: isTablet ? 36 : 28,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(height: 8),
                                          Flexible(
                                            child: Text(
                                              'طاولة ${table.tableNumber}',
                                              style: TextStyle(
                                                fontSize: isTablet ? 18 : 14,
                                                color: Colors.white,
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Flexible(
                                            child: Text(
                                              'عدد الأشخاص ${table.chairNumber}',
                                              style: TextStyle(
                                                fontSize: isTablet ? 15 : 13,
                                                color: Colors.white70,
                                                fontFamily: 'Tajawal',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Flexible(
                                            child: Text(
                                              table.available ? 'متاحة' : 'مشغولة',
                                              style: TextStyle(
                                                fontSize: isTablet ? 14 : 12,
                                                color: Colors.white70,
                                                fontFamily: 'Tajawal',
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (state is tableErrorState) {
                          return Center(
                            child: Text(
                              'خطأ في تحميل الطاولات',
                              style: TextStyle(color: Colors.redAccent, fontSize: 16),
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
