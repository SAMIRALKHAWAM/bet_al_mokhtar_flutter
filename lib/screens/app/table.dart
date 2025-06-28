import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:flutter/cupertino.dart';
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
    final cubit = AppCubit.get(context);
    cubit.Table_get();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'الطاولات',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<AppCubit, AppSates>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is tableSuccessState) {
                      final tables = AppCubit.get(context).Table_model?.data ?? [];
                      if (tables.isEmpty) {
                        return Center(child: Text('لا توجد طاولات متاحة', style: TextStyle(color: Colors.white)));
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: GridView.builder(
                          itemCount: tables.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 4 : 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: isTablet ? 1 : 0.8,  // تعديل صغير لارتفاع العنصر
                          ),
                          itemBuilder: (context, index) {
                            final table = tables[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => WaiterOrderInterface(table.id)));
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: table.available ? Colors.green[400] : Colors.red[400],
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Icon(
                                        table.available ? Icons.event_available : Icons.restaurant,
                                        size: isTablet ? 36 : 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
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
                                        softWrap: false,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'عدد الأشخاص ${table.chairNumber}',
                                        style: TextStyle(
                                          fontSize: isTablet ? 15 : 13,
                                          color: Colors.white,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
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
                                        softWrap: false,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )

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
  }
}
