import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/auth/login.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../blocs/auth_cubit/cubit.dart';
import '../../blocs/auth_cubit/statuse.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';
import '../../network/cash_helper.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) async {
        if (state is Login_UserSuccessState) {
          final response = state.loginModel.data;

          // حفظ البيانات الأساسية
          await CachHelper.saveData(key: "token", value: response.token.toString());
          await CachHelper.saveData(key: "id", value: response.id.toString());

          // الحصول على FCM Token
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          print("📱 FCM Token بعد التسجيل: $fcmToken");
          await CachHelper.saveData(key: "fcm_token", value: fcmToken);

          // انتقل إلى صفحة تسجيل الدخول
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        }

        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(tr('signup_error', args: ['حدث خطأ أثناء التسجيل']))),
          );
        }
      },
      builder: (context, authState) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: Stack(
            children: [
              Container(
                height: 280,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
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
              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        CustomText(
                          text1: tr('create_account'),
                          size: 30,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 8),
                        CustomText(
                          text1: tr('create_account_desc'),
                          size: 15,
                          color: theme.colorScheme.onPrimary.withOpacity(0.95),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
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
                                  controller: nameController,
                                  hint: tr('your_full_name'),
                                  keyboardType: TextInputType.name,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),

                                const SizedBox(height: 15),
                                CustomTextFormField(
                                  controller: passwordController,
                                  hint: tr('create_password'),
                                  obscureText: true,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                CustomTextFormField(
                                  controller: confirmPasswordController,
                                  hint: tr('confirm_password'),
                                  obscureText: true,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.lock_open,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 25),
                                DefaultButton(
                                  onTap: () {
                                    if (formKey.currentState?.validate() ?? false) {
                                      if (passwordController.text != confirmPasswordController.text) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(tr('passwords_not_match'))),
                                        );
                                        return;
                                      }
                                      AuthCubit.get(context).SinUp(
                                        user_name: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  text: tr('join_now'),
                                  color: theme.colorScheme.primary,
                                  textColor: theme.colorScheme.onPrimary,
                                  size: 18,
                                  width: double.infinity,
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text1: tr('already_have_account'),
                                      color: theme.textTheme.bodySmall?.color ?? Colors.black54,
                                      size: 12,
                                    ),
                                    TextButtonCustom(
                                      text: tr('login'),
                                      backgroundColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => LoginPage()),
                                        );
                                      },
                                      color: theme.colorScheme.primary,
                                      size: 14,
                                      padding: const EdgeInsets.only(bottom: 0),
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
