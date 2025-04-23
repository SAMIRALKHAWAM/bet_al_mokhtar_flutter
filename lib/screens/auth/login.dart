// import 'package:almoktar/screens/auth/signup.dart';
// import 'package:flutter/material.dart';
// import '../../components/colors.dart';
// import '../../components/defaultButton.dart';
// import '../../components/text.dart';
// import '../../components/textButton.dart';
// import '../../components/textfromfilde.dart';

// class LoginPage extends StatelessWidget {
//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorApp.colorback,
//       body: Stack(
//         children: [
//           Container(
//             height: 280,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [ColorApp.color1, ColorApp.color4],
//                 //colors: [Color(0xffEF2A39), Color(0xffFFA726)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(50),
//                 bottomRight: Radius.circular(50),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.1),
//                   blurRadius: 30,
//                   spreadRadius: 3,
//                   offset: Offset(0, 8),
//                 ),
//               ],
//             ),
//           ),

//           Center(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 50),

//                     CustomText(
//                       text1: "Login",
//                       size: 36,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),

//                     const SizedBox(height: 10),

//                     CustomText(
//                       text1: "Welcome back 👋👋🏻",
//                       size: 18,
//                       color: Colors.white,
//                     ),

//                     const SizedBox(height: 50),

//                     Container(
//                       padding: const EdgeInsets.all(30),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(30),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 20,
//                             offset: Offset(0, 6),
//                           ),
//                         ],
//                       ),
//                       child: Form(
//                         key: formKey,
//                         child: Column(
//                           children: [
//                             CustomTextFormField(
//                               controller: emailController,
//                               hint: 'Enter your email',
//                               keyboardType: TextInputType.emailAddress,
//                               radius: 15,
//                               color : Colors.grey[200],
//                               prefixIcon: Icon(Icons.email_outlined),

//                             ),
//                             const SizedBox(height: 20),

//                             CustomTextFormField(
//                               controller: passwordController,
//                               hint: 'Enter your password',
//                               obscureText: true,
//                               radius: 15,
//                               color : Colors.grey[200],
//                               prefixIcon: Icon(Icons.lock),

//                             ),

//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButtonCustom(
//                                 text: "Forgot Password?",
//                                 onTap: () {
//                                   print("Forgot password tapped");
//                                 },
//                                 color: Colors.blueAccent,
//                                 size: 14,
//                                 padding: EdgeInsets.only(bottom: 0),
//                               ),
//                             ),

//                             const SizedBox(height: 30),

//                             DefaultButton(
//                               onTap: () {
//                                 if (formKey.currentState!.validate()) {
//                                   print("Logged in successfully");
//                                 }
//                               },
//                               text: 'Login',
//                               color: ColorApp.color1,
//                               textColor: Colors.white,
//                               size: 18,
//                               width: double.infinity,
//                             ),

//                             const SizedBox(height: 15),

//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CustomText(
//                                   text1: "Don't have an account?",
//                                   color: Colors.black54,
//                                   size: 12,
//                                 ),
//                                 TextButtonCustom(
//                                   text: 'Sign Up',
//                                   onTap: () {
//                                     Navigator.push(context,MaterialPageRoute(builder: (context) =>SignUpPage()));

//                                   },
//                                   color: ColorApp.color1,
//                                   size: 14,
//                                  padding : EdgeInsets.only(bottom: 0),

//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:almoktar/config/theme_manager.dart';
import 'package:almoktar/cubits/theme/theme_cubit.dart';
import 'package:almoktar/screens/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';

class LoginPage extends StatelessWidget {
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
                          text1: "Login",
                          size: 36,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          text1: "Welcome back 👋👋🏻",
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
                                  hint: 'Enter your email',
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
                                  hint: 'Enter your password',
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
                                    text: "Forgot Password?",
                                    onTap: () {
                                      print("Forgot password tapped");
                                    },
                                    color: theme.colorScheme.secondary,
                                    size: 14,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                DefaultButton(
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      print("Logged in successfully");
                                    }
                                  },
                                  text: 'Login',
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
                                      text1: "Don't have an account?",
                                      color: theme.textTheme.bodyMedium?.color,
                                      size: 12,
                                    ),
                                    TextButtonCustom(
                                      text: 'Sign Up',
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
                                ListTile(
                                  leading: Icon(
                                    BlocProvider.of<ThemeCubit>(context).isDark
                                        ? Icons.dark_mode
                                        : Icons.light_mode,
                                  ),
                                  title: Text(
                                    'theme',
                                    style:
                                        Theme.of(
                                          context,
                                        ).textTheme.displayLarge,
                                  ),
                                  onTap: () {
                                    // عند الضغط على Settings، تغيير الثيم
                                    BlocProvider.of<ThemeCubit>(
                                      context,
                                    ).switchTheme();
                                    // Navigator.pop(context); // إغلاق الـ Drawer بعد التغيير
                                  },
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
