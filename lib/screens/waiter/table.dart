import 'package:almoktar/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import '../../blocs/auth_cubit/cubit.dart';
import '../../components/colors.dart';
import 'ReadyOrderScreen.dart';
import 'emp.dart';

class TablesScreen extends StatefulWidget {
  @override
  State<TablesScreen> createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  @override
  void initState() {
    super.initState();
    AppCubit.get(context).Table_get();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return BlocConsumer<AppCubit, AppSates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: ColorApp.accent,
            title: Text('الطاولات', style: TextStyle(fontFamily: 'Tajawal')),
            centerTitle: true,
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
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => AppCubit.get(context).Table_get(),
              ),
              IconButton(
                icon: Icon(Icons.assignment_turned_in_outlined),
                tooltip: "الطلبات الجاهزة",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ReadyOrdersScreen()),
                  );
                },
              ),
            ],
          ),

          body: Padding(
            padding: const EdgeInsets.all(16),
            child:
                state is LoadingState
                    ? Center(child: CircularProgressIndicator())
                    : state is tableErrorState
                    ? Center(child: Text('خطأ في تحميل الطاولات'))
                    : BlocBuilder<AppCubit, AppSates>(
                      builder: (context, state) {
                        final tables =
                            AppCubit.get(context).Table_model?.data ?? [];

                        if (tables.isEmpty) {
                          return Center(child: Text('لا توجد طاولات متاحة'));
                        }

                        return GridView.builder(
                          itemCount: tables.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isTablet ? 4 : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1,
                              ),
                          itemBuilder: (context, index) {
                            final table = tables[index];
                            final isAvailable = table.available;

                            return GestureDetector(
                              onTap: () {
                                if (isAvailable) {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: Text('فتح الطاولة'),
                                          content: Text(
                                            'هل تريد فتح الطاولة رقم ${table.tableNumber}?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: Text('إلغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                AppCubit.get(
                                                  context,
                                                ).table_change_statu(
                                                  table_id: table.id,
                                                );
                                                AppCubit.get(context).Table_get();

                                                Navigator.pop(context);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (_) =>
                                                            WaiterOrderInterface(
                                                              table.id,
                                                              table.tableNumber,
                                                              table.invoice_id,
                                                            ),
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
                                      builder:
                                          (_) => WaiterOrderInterface(
                                            table.id,
                                            table.tableNumber,
                                            table.invoice_id,
                                          ),
                                    ),
                                  );
                                }
                              },
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isAvailable
                                                    ? Colors.green[100]
                                                    : Colors.red[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            isAvailable
                                                ? 'متاحة ✅'
                                                : 'مشغولة ⛔',
                                            style: TextStyle(
                                              color:
                                                  isAvailable
                                                      ? Colors.green[800]
                                                      : Colors.red[800],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/images/table.png',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.contain,
                                      ),

                                      Text(
                                        'طاولة ${table.tableNumber}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        'عدد الأشخاص: ${table.chairNumber}',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        );
      },
    );
  }
}
