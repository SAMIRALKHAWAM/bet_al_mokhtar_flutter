import 'package:almoktar/blocs/auth_cubit/cubit.dart';
import 'package:almoktar/blocs/cubit_app/cubit.dart';
import 'package:almoktar/blocs/cubit_app/statues.dart';
import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/password_visibility/password_visibility_cubit.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/network/end_point.dart';
import 'package:almoktar/screens/app/layout.dart';
import 'package:almoktar/screens/auth/signup.dart';
import 'package:almoktar/screens/waiter/table.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../blocs/auth_cubit/statuse.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';
import '../../network/cash_helper.dart';
import '../chief/chef_order.dart';
import '../delivery/delivery_order.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) async {
        if (state is LoginSuccessState) {
          // 🧠 تخزين بيانات المستخدم
          await CachHelper.saveData(key: "token", value: AuthCubit.get(context).loginModel?.data.token.toString());
          await CachHelper.saveData(key: "role", value: AuthCubit.get(context).loginModel?.data.type.toString());
          await CachHelper.saveData(key: "id", value: AuthCubit.get(context).loginModel?.data.id.toString());
          await CachHelper.saveData(key: "branch_id", value: AuthCubit.get(context).loginModel?.data.branchId.toString());
          await CachHelper.saveData(key: "emp_id", value: AuthCubit.get(context).loginModel?.data.id.toString());

          // استرجاع القيم
          role = CachHelper.getData(key: "role");
          emp_id = CachHelper.getData(key: "id");
          branch_id = CachHelper.getData(key: "branch_id");
          token = CachHelper.getData(key: "token");

          print("🔐 Token: $token");
          print("👤 Role: $role");

          // ✅ احصل على FCM Token بعد تسجيل الدخول
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          print("📱 FCM Token بعد تسجيل الدخول: $fcmToken");

          // ✅ خزن الـ FCM Token محلياً
          await CachHelper.saveData(key: "fcm_token", value: fcmToken);

          // ✅ (اختياري) إرسال التوكن للسيرفر:
          // await DioHelper.postData(
          //   url: 'save-fcm-token-endpoint',
          //   data: {
          //     'user_id': emp_id,
          //     'fcm_token': fcmToken,
          //   },
          // );

          // ✅ التوجيه بناءً على الدور
          if (role == "waiter") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TablesScreen()),
            );
          } else if (role == "deliveryman") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DeliveryOrders()),
            );
          } else if (role == "captain") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChefOrdersExpansionPanelPage()),
            );
          }
        }
      },
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
                    colors: [theme.primaryColor, theme.primaryColorDark],
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
                        Text(
                          "login".tr(),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "welcome_back".tr(),
                          style: TextStyle(
                            fontSize: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          padding: const EdgeInsets.all(30),
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
                                TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    hintText: "enter_email".tr(),
                                    prefixIcon: Icon(Icons.email_outlined),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                BlocBuilder<PasswordVisibilityCubit, PasswordVisibilityState>(
                                  builder: (context, stateVisibility) {
                                    return TextFormField(
                                      controller: passwordController,
                                      obscureText: stateVisibility.isObscure,
                                      decoration: InputDecoration(
                                        hintText: "enter_password".tr(),
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            stateVisibility.isObscure ? Icons.visibility_off : Icons.visibility,
                                          ),
                                          onPressed: () {
                                            context.read<PasswordVisibilityCubit>().toggleVisibility();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      print("Forgot password tapped");
                                    },
                                    child: Text("forgot_password".tr()),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      AuthCubit.get(context).Login_emp(
                                        user_name: emailController.text,
                                        password: passwordController.text,
                                      );
                                    }
                                  },
                                  child: Text("login".tr()),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("dont_have_account".tr()),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpPage(),
                                          ),
                                        );
                                      },
                                      child: Text("sign_up".tr()),
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
