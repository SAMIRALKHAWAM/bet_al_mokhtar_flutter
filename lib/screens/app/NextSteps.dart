import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/components/defaultButton.dart';
import '../../models/get_branch.dart';

class OrderNextStep extends StatefulWidget {
  const OrderNextStep({Key? key}) : super(key: key);

  @override
  State<OrderNextStep> createState() => _OrderNextStepState();
}

class _OrderNextStepState extends State<OrderNextStep> {
  BranchModel? selectedBranch;
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController discountCodeController = TextEditingController();

  bool isDiscountValid = false;
  bool isDiscountChecked = false;
  bool isPhoneValid = true;
  String? discountMessage;

  bool get isFormValid {
    final isBranchSelected = selectedBranch != null;
    final isAddressFilled = addressController.text.trim().isNotEmpty;
    final isPhoneFilled = phoneController.text.trim().isNotEmpty;
    final isPhoneCorrect = RegExp(r'^09\d{8}$').hasMatch(phoneController.text.trim());
    final isDiscountOk = discountCodeController.text.isEmpty
        ? true
        : (isDiscountChecked && isDiscountValid);

    return isBranchSelected && isAddressFilled && isPhoneFilled && isPhoneCorrect && isDiscountOk;
  }

  @override
  void initState() {
    super.initState();
    AppCubit.get(context).Branch();

    discountCodeController.addListener(() {
      final code = discountCodeController.text.trim();
      setState(() {
        isDiscountValid = code.length >= 6;
        if (!isDiscountValid && code.isNotEmpty) {
          isDiscountChecked = false;
          discountMessage = "الكود يجب أن يكون 6 خانات على الأقل";
        } else {
          discountMessage = null;
        }
      });
    });

    phoneController.addListener(() {
      setState(() {
        final phone = phoneController.text.trim();
        isPhoneValid = phone.isEmpty || RegExp(r'^09\d{8}$').hasMatch(phone);
      });
    });

    addressController.addListener(() => setState(() {}));
  }

  void clearForm() {
    addressController.clear();
    phoneController.clear();
    discountCodeController.clear();
    selectedBranch = null;
    isDiscountChecked = false;
    isDiscountValid = false;
    discountMessage = null;
    AppCubit.get(context).orderItems.clear();
    AppCubit.get(context).orderOffers.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الطلب"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 0.5,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: BlocListener<AppCubit, AppSates>(
          listener: (context, state) {
            if (state is DiscountSuccessState) {
              setState(() {
                isDiscountChecked = true;
                discountMessage = "تم التحقق من كود الخصم بنجاح!";
              });
            } else if (state is DiscountErrorState) {
              setState(() {
                isDiscountChecked = false;
                discountMessage = "كود الخصم غير صالح";
              });
            } else if (state is addcartSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(

                const SnackBar(content: Text("تم إرسال الطلب بنجاح")),
              );
              clearForm();
              Navigator.pop(context);
            } else if (state is addcartErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("حدث خطأ أثناء إرسال الطلب")),
              );
            }
          },
          child: BlocBuilder<AppCubit, AppSates>(
            builder: (context, state) {
              final cubit = AppCubit.get(context);

              if (state is LoadingState && cubit.branch_model == null) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BranchErrorState) {
                return const Center(child: Text("حدث خطأ في تحميل الفروع"));
              }

              final branches = cubit.branch_model?.data ?? [];

              if (branches.isEmpty) {
                return const Center(child: Text("لا توجد فروع متاحة حالياً"));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("اختر الفرع", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<BranchModel>(
                    value: branches.contains(selectedBranch) ? selectedBranch : null,
                    hint: const Text("اختر فرع المطعم"),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: branches.map((branch) {
                      return DropdownMenuItem(
                        value: branch,
                        child: Text(branch.name),
                      );
                    }).toList(),
                    onChanged: (branch) {
                      setState(() {
                        selectedBranch = branch;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  Text("العنوان", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "أدخل عنوان التوصيل بالتفصيل",
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 20),

                  Text("رقم الجوال", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "مثال: 09XXXXXXXX",
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorText: phoneController.text.isNotEmpty && !isPhoneValid
                          ? "رقم الهاتف غير صحيح"
                          : null,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 20),

                  Text("كود الخصم", style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: discountCodeController,
                              decoration: InputDecoration(
                                hintText: "أدخل كود الخصم",
                                filled: true,
                                fillColor: theme.cardColor,
                                suffixIcon: isDiscountChecked
                                    ? const Icon(Icons.check_circle, color: Colors.green)
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: 4),
                            if (discountMessage != null)
                              Text(
                                discountMessage!,
                                style: TextStyle(
                                  color: isDiscountChecked ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: isDiscountValid
                            ? () {
                          final code = discountCodeController.text.trim();
                          AppCubit.get(context)
                              .getDiscounts(discountCode: code);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("تحقق"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  DefaultButton(
                    onTap: () {
                      if (!isFormValid) return;

                      final cubit = AppCubit.get(context);
                      cubit.create_external_order(
                        branch_id: selectedBranch!.id,
                        location: addressController.text.trim(),
                        phone: phoneController.text.trim(),
                        discount_code: discountCodeController.text.trim(),
                      );
                    },
                    text: "متابعة",
                    color: isFormValid ? theme.colorScheme.primary : Colors.grey,
                    textColor: theme.colorScheme.onPrimary,
                    width: double.infinity,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
