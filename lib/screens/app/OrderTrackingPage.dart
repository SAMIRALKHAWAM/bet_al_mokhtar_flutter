// import 'package:almoktar/blocs/cubit_app/cubit.dart';
// import 'package:almoktar/blocs/cubit_app/statues.dart';
// import 'package:almoktar/components/defaultButton.dart';
// import 'package:almoktar/cubits/theme/theme_cubit.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class OrderTrackingPage extends StatelessWidget {
//   const OrderTrackingPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ThemeCubit, ThemeState>(
//       builder: (context, state) {
//         final theme = Theme.of(context);
//
//         return Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             title: Text("تتبع الطلب", style: theme.textTheme.titleLarge),
//             backgroundColor: theme.colorScheme.primary,
//             foregroundColor: theme.colorScheme.onPrimary,
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(25),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 20),
//                 BlocBuilder<AppCubit, AppSates>(
//                   builder: (context, state) {
//                     return Column(
//                       children: [
//                         _buildStep(
//                           theme,
//                           label: "قيد التحضير",
//                           isActive: state is OrderPreparing,
//                         ),
//                         _buildLine(theme),
//                         _buildStep(
//                           theme,
//                           label: "في الطريق",
//                           isActive: state is OrderOnTheWay,
//                         ),
//                         _buildLine(theme),
//                         _buildStep(
//                           theme,
//                           label: "تم التوصيل",
//                           isActive: state is OrderDelivered,
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 Text("تغيير الحالة:", style: theme.textTheme.titleMedium),
//                 const SizedBox(height: 15),
//                 DefaultButton(
//                   onTap: () => context.read<AppCubit>().setPreparing(),
//                   text: "قيد التحضير",
//                   color: theme.colorScheme.primary,
//                   textColor: theme.colorScheme.onPrimary,
//                   width: double.infinity,
//                 ),
//                 const SizedBox(height: 10),
//                 DefaultButton(
//                   onTap: () => context.read<AppCubit>().setOnTheWay(),
//                   text: "في الطريق",
//                   color: theme.colorScheme.secondary,
//                   textColor: theme.colorScheme.onSecondary,
//                   width: double.infinity,
//                 ),
//                 const SizedBox(height: 10),
//                 DefaultButton(
//                   onTap: () => context.read<AppCubit>().setDelivered(),
//                   text: "تم التوصيل",
//                   color: theme.colorScheme.tertiary,
//                   textColor: theme.colorScheme.onTertiary,
//                   width: double.infinity,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildStep(
//     ThemeData theme, {
//     required String label,
//     required bool isActive,
//   }) {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 12,
//           backgroundColor:
//               isActive
//                   ? theme.colorScheme.primary
//                   : theme.colorScheme.surfaceVariant,
//           child: Icon(
//             Icons.check,
//             size: 16,
//             color:
//                 isActive
//                     ? theme.colorScheme.onPrimary
//                     : theme.colorScheme.onSurfaceVariant,
//           ),
//         ),
//         const SizedBox(width: 10),
//         Text(label, style: theme.textTheme.titleSmall),
//       ],
//     );
//   }
//
//   Widget _buildLine(ThemeData theme) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       height: 2,
//       width: double.infinity,
//       color: theme.colorScheme.outlineVariant,
//     );
//   }
// }
