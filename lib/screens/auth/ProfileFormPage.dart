import 'package:almoktar/components/defaultButton.dart';

import 'package:almoktar/components/textfromfilde.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileFormPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final mobileController = TextEditingController();
  final pincodeController = TextEditingController();
  final genderController = TextEditingController();
  final cityController = TextEditingController();
  String? selectedState;

  ProfileFormPage({super.key});

  final List<String> states = ['Delhi', 'Mumbai', 'Karnataka', 'Punjab'];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text("Profile", style: theme.textTheme.titleLarge),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextFormField(
                          controller: nameController,
                          hint: 'Name',
                          radius: 15,
                          color: theme.colorScheme.onSecondaryFixed,
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: addressController,
                          hint: 'Address',
                          radius: 15,
                          color: theme.colorScheme.onSecondaryFixed,
                        ),
                        const SizedBox(height: 15),
                        CustomTextFormField(
                          controller: mobileController,
                          hint: 'Mobile Number',
                          keyboardType: TextInputType.phone,
                          radius: 15,
                          color: theme.colorScheme.onSecondaryFixed,
                        ),
                        const SizedBox(height: 15),

                        // Pincode + Gender
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: pincodeController,
                                hint: 'Pincode',
                                radius: 15,
                                color: theme.colorScheme.onSecondaryFixed,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextFormField(
                                controller: genderController,
                                hint: 'Gender',
                                radius: 15,
                                color: theme.colorScheme.onSecondaryFixed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // City + State (dropdown)
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: cityController,
                                hint: 'City',
                                radius: 15,
                                color: theme.colorScheme.onSecondaryFixed,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: selectedState,
                                hint: const Text("State"),
                                items:
                                    states
                                        .map(
                                          (state) => DropdownMenuItem(
                                            value: state,
                                            child: Text(state),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (value) {
                                  selectedState = value;
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
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),
                        DefaultButton(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              print("Saved");
                              // تنفيذ الحفظ هنا
                            }
                          },

                          text: 'SAVE',
                          color: theme.colorScheme.primary,
                          textColor: theme.colorScheme.onPrimary,
                          size: 18,
                          width: double.infinity,
                        ),
                      ],
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
