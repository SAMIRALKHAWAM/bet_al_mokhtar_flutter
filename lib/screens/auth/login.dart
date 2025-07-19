import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/app/layout.dart';
import 'package:almoktar/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.gradientStart, theme.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 3,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        CustomText(
                          text1: "login".tr(),
                          size: 36,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          text1: "welcome_back".tr(),
                          size: 18,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: theme.cardColor ?? theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: emailController,
                                  hint: 'enter_email'.tr(),
                                  keyboardType: TextInputType.emailAddress,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextFormField(
                                  controller: passwordController,
                                  hint: 'enter_password'.tr(),
                                  obscureText: true,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButtonCustom(
                                    text: "forgot_password".tr(),
                                    onTap: () {
                                      print("Forgot password tapped");
                                    },
                                    color: theme.colorScheme.secondary,
                                    size: 14,
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.black.withOpacity(
                                      0.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                DefaultButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      print("Logged in successfully");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LayoutScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  text: 'login'.tr(),
                                  color: theme.colorScheme.primary,
                                  textColor: theme.buttonTextColor,
                                  size: 18,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text1: "dont_have_account".tr(),
                                      color: theme.textTheme.bodyMedium?.color,
                                      size: 12,
                                    ),
                                    TextButtonCustom(
                                      text: 'sign_up'.tr(),
                                      backgroundColor: Colors.black.withOpacity(
                                        0.0,
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpPage(),
                                          ),
                                        );
                                      },
                                      color: theme.colorScheme.primary,
                                      size: 14,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
