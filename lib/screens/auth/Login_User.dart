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

class LoginUserPage extends StatelessWidget {
  LoginUserPage({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if(state is Login_UserSuccessState){
          CachHelper.saveData(key: "token", value: AuthCubit.get(context).loginResponse?.data.token.toString());
          CachHelper.saveData(key: "id", value: AuthCubit.get(context).loginResponse?.data.id.toString());


          id=CachHelper.getData(key: "id");


          token=CachHelper.getData(key: "token");
          print(token);




          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LayoutScreen(),
            ),
          );

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
                                  // keyboardType: TextInputType.emailAddress,
                                  radius: 15,
                                  color: theme.colorScheme.onSecondaryFixed,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                BlocBuilder<
                                    PasswordVisibilityCubit,
                                    PasswordVisibilityState
                                >(
                                  builder: (context, stateVisibility) {
                                    return CustomTextFormField(
                                      controller: passwordController,
                                      hint:'enter_password'.tr(),
                                      obscureText: stateVisibility.isObscure,
                                      radius: 15,
                                      color: theme.colorScheme.onSecondaryFixed,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: theme.colorScheme.primary,
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          stateVisibility.isObscure
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          context
                                              .read<PasswordVisibilityCubit>()
                                              .toggleVisibility();
                                        },
                                      ),
                                    );
                                  },
                                ),

                                // CustomTextFormField(
                                //   controller: passwordController,
                                //   hint: 'enter_password'.tr(),
                                //   obscureText: true,
                                //   radius: 15,
                                //   color: theme.colorScheme.onSecondaryFixed,
                                //   prefixIcon: Icon(
                                //     Icons.lock,
                                //     color: theme.colorScheme.primary,
                                //   ),
                                // ),

                                const SizedBox(height: 30),
                                DefaultButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {

                                      AuthCubit.get(context).Login_user(
                                          user_name:emailController.text ,
                                          password:passwordController.text);
                                      print("Logged in successfully");

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
