// import 'package:almoktar/components/defaultButton.dart';
// import 'package:almoktar/cubits/theme/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class Order {
//   final String title;
//   final String date;
//   final String status;
//   final double total;

//   Order({
//     required this.title,
//     required this.date,
//     required this.status,
//     required this.total,
//   });
// }

// class OrderHistoryPage extends StatelessWidget {
//   OrderHistoryPage({super.key});

//   final List<Order> orders = [
//     Order(title: "طلب #1234", date: "2024-05-01", status: "تم التوصيل", total: 99.5),
//     Order(title: "طلب #1228", date: "2024-04-28", status: "في الطريق", total: 45.0),
//     Order(title: "طلب #1221", date: "2024-04-25", status: "قيد التحضير", total: 72.3),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);

//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             title: Text("سجل الطلبات", style: theme.textTheme.titleLarge),
//             backgroundColor: theme.colorScheme.primary,
//             foregroundColor: theme.colorScheme.onPrimary,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(20),
//             child: ListView.separated(
//               itemCount: orders.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 15),
//               itemBuilder: (context, index) {
//                 final order = orders[index];
//                 return Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: theme.colorScheme.surfaceVariant,
//                     borderRadius: BorderRadius.circular(15),
//                     boxShadow: [
//                       BoxShadow(
//                         color: theme.shadowColor.withOpacity(0.1),
//                         blurRadius: 8,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(order.title, style: theme.textTheme.titleMedium),
//                       const SizedBox(height: 8),
//                       Text("التاريخ: ${order.date}", style: theme.textTheme.bodyMedium),
//                       const SizedBox(height: 4),
//                       Text("الحالة: ${order.status}", style: theme.textTheme.bodyMedium),
//                       const SizedBox(height: 4),
//                       Text("الإجمالي: \$${order.total.toStringAsFixed(2)}", style: theme.textTheme.bodyMedium),
//                       const SizedBox(height: 12),
//                       DefaultButton(
//                         onTap: () {
//                           // إعادة الطلب أو أي وظيفة أخرى
//                         },
//                         text: "إعادة الطلب",
//                         color: theme.colorScheme.primary,
//                         textColor: theme.colorScheme.onPrimary,
//                         width: double.infinity,
//                         size: 16,
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


////////////////////////////////////////////////////////////////////////////
///

// import 'package:almoktar/blocs/cubit_app/cubit.dart';
// import 'package:almoktar/blocs/cubit_app/statues.dart';
// import 'package:almoktar/components/defaultButton.dart';
// import 'package:almoktar/cubits/theme/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class OrderHistoryPage extends StatelessWidget {
//   const OrderHistoryPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return BlocProvider(
//       create: (_) => OrderCubit()..fetchOrders(),
//       child: BlocBuilder<ThemeCubit, ThemeState>(
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: theme.scaffoldBackgroundColor,
//             appBar: AppBar(
//               title: Text("سجل الطلبات", style: theme.textTheme.titleLarge),
//               backgroundColor: theme.colorScheme.primary,
//               foregroundColor: theme.colorScheme.onPrimary,
//             ),
//             body: BlocBuilder<AppCubit, AppSates>(
//               builder: (context, state) {
//                 if (state is OrderLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is OrderError) {
//                   return Center(child: Text(state.message));
//                 } else if (state is OrderLoaded) {
//                   final orders = state.orders;

//                   return Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: ListView.separated(
//                       itemCount: orders.length,
//                       separatorBuilder: (_, __) => const SizedBox(height: 15),
//                       itemBuilder: (context, index) {
//                         final order = orders[index];
//                         return Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.surfaceVariant,
//                             borderRadius: BorderRadius.circular(15),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: theme.shadowColor.withOpacity(0.1),
//                                 blurRadius: 8,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(order.title, style: theme.textTheme.titleMedium),
//                               const SizedBox(height: 8),
//                               Text("التاريخ: ${order.date}", style: theme.textTheme.bodyMedium),
//                               const SizedBox(height: 4),
//                               Text("الحالة: ${order.status}", style: theme.textTheme.bodyMedium),
//                               const SizedBox(height: 4),
//                               Text("الإجمالي: \$${order.total.toStringAsFixed(2)}", style: theme.textTheme.bodyMedium),
//                               const SizedBox(height: 12),
//                               DefaultButton(
//                                 onTap: () {
//                                   // تنفيذ أمر إعادة الطلب
//                                 },
//                                 text: "إعادة الطلب",
//                                 color: theme.colorScheme.primary,
//                                 textColor: theme.colorScheme.onPrimary,
//                                 width: double.infinity,
//                                 size: 16,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 }

//                 return const SizedBox.shrink();
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
