import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/textfromfilde.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import '../../models/get_branch.dart';

class TableBookingPage extends StatefulWidget {
  const TableBookingPage({super.key});

  @override
  State<TableBookingPage> createState() => _TableBookingPageState();
}

class _TableBookingPageState extends State<TableBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final peopleCountController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  BranchModel? selectedBranch;

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).Branch(); // جلب الفروع من السيرفر
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final branches = AppCubit.get(context).branch_model?.data ?? [];

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("Book a Table", style: theme.textTheme.titleLarge),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// الاسم
                  CustomTextFormField(
                    controller: nameController,
                    hint: 'Your Name',
                    radius: 15,
                    color: theme.colorScheme.onSecondaryFixed,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// عدد الأشخاص
                  CustomTextFormField(
                    controller: peopleCountController,
                    hint: 'Number of People',
                    keyboardType: TextInputType.number,
                    radius: 15,
                    color: theme.colorScheme.onSecondaryFixed,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of people';
                      }
                      final number = int.tryParse(value);
                      if (number == null) {
                        return 'Please enter a valid number';
                      }
                      if (number < 2) {
                        return 'Minimum 2 people required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  /// اختيار التاريخ
                  GestureDetector(
                    onTap: () async {
                      final tomorrow = DateTime.now().add(const Duration(days: 1));
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: tomorrow,
                        firstDate: tomorrow,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                              : "",
                        ),
                        hint: 'Select Date',
                        radius: 15,
                        color: theme.colorScheme.onSecondaryFixed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// اختيار الوقت
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        setState(() => selectedTime = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: TextEditingController(
                          text: selectedTime != null
                              ? selectedTime!.format(context)
                              : "",
                        ),
                        hint: 'Select Time',
                        radius: 15,
                        color: theme.colorScheme.onSecondaryFixed,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// اختيار الفرع
                  DropdownButtonFormField<BranchModel>(
                    value: branches.contains(selectedBranch) ? selectedBranch : null,
                    hint: const Text("Choose a Branch"),
                    items: branches.map((branch) {
                      return DropdownMenuItem(
                        value: branch,
                        child: Text(branch.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedBranch = value);
                    },
                    validator: (value) {
                      if (selectedBranch == null) {
                        return 'Please choose a branch';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                      filled: true,
                      fillColor: theme.colorScheme.onSecondaryFixed,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// زر تأكيد الحجز
                  DefaultButton(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          selectedDate != null &&
                          selectedTime != null &&
                          selectedBranch != null) {
                        final now = DateTime.now();
                        final tomorrow = DateTime(now.year, now.month, now.day + 1);
                        final bookingDate = DateTime(
                          selectedDate!.year,
                          selectedDate!.month,
                          selectedDate!.day,
                        );

                        if (bookingDate.isBefore(tomorrow)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Booking must be at least 1 day in advance."),
                            ),
                          );
                          return;
                        }

                        /// ✅ استدعاء دالة الحجز
                        AppCubit.get(context).add_table_reservation(
                          date:
                          "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}",
                          from_time:
                          "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                          to_time: _calculateToTime(selectedTime!),
                          branch_id: selectedBranch!.id.toString(),
                          chairs: peopleCountController.text,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please complete all fields.")),
                        );
                      }
                    },
                    text: 'Confirm Reservation',
                    color: theme.colorScheme.primary,
                    textColor: theme.colorScheme.onPrimary,
                    size: 18,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// حساب وقت الانتهاء بعد ساعة
  String _calculateToTime(TimeOfDay fromTime) {
    final endTime = TimeOfDay(
      hour: (fromTime.hour + 1) % 24,
      minute: fromTime.minute,
    );
    return "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
  }
}
