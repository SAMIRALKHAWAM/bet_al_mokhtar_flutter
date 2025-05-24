import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/textfromfilde.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';

//////لإنشاء واجهة "حجز طاولة
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

  // قائمة الطاولات المتاحة (كمثال)
  final List<String> availableTables = [
    "Table 1 (2 people)",
    "Table 2 (4 people)",
    "Table 3 (6 people)",
    "Table 4 (8 people)",
  ];
  String? selectedTable;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

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
                  // ✅ الاسم
                  CustomTextFormField(
                    controller: nameController,
                    hint: 'Your Name',
                    radius: 15,
                    color: theme.colorScheme.onSecondaryFixed,
                  ),
                  const SizedBox(height: 15),

                  // ✅ عدد الأشخاص
                  CustomTextFormField(
                    controller: peopleCountController,
                    hint: 'Number of People',
                    keyboardType: TextInputType.number,
                    radius: 15,
                    color: theme.colorScheme.onSecondaryFixed,
                  ),
                  const SizedBox(height: 15),

                  // ✅ اختيار التاريخ
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        controller: TextEditingController(
                          text:
                              selectedDate != null
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

                  // ✅ اختيار الساعة
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
                          text:
                              selectedTime != null
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

                  // ✅ اختيار الطاولة
                  DropdownButtonFormField<String>(
                    value: selectedTable,
                    hint: const Text("Choose a Table"),
                    items:
                        availableTables
                            .map(
                              (table) => DropdownMenuItem(
                                value: table,
                                child: Text(table),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => selectedTable = value);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 16,
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.onSecondaryFixed,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ✅ زر تأكيد الحجز
                  DefaultButton(
                    onTap: () {
                      if (_formKey.currentState!.validate() &&
                          selectedDate != null &&
                          selectedTime != null &&
                          selectedTable != null) {
                        // تنفيذ الحجز هنا
                        print("Reservation confirmed");
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
}
