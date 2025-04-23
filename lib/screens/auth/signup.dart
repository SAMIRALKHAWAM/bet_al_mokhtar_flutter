import 'package:almoktar/screens/auth/login.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/defaultButton.dart';
import '../../components/text.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';

class SignUpPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.colorback,
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorApp.color1, ColorApp.color4],
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
                  offset: Offset(0, 8),
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
                      text1: "Create Account",
                      size: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    CustomText(
                      text1: "Create an account to start ordering!",
                      size: 15,
                      color: Colors.white.withOpacity(0.95),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextFormField(
                              controller: nameController,
                              hint: 'Your Full Name',
                              keyboardType: TextInputType.name,
                              radius: 15,
                              color: Colors.grey[200],
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: emailController,
                              hint: 'Email Address',
                              keyboardType: TextInputType.emailAddress,
                              radius: 15,
                              color: Colors.grey[200],
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: passwordController,
                              hint: 'Create Password',
                              obscureText: true,
                              radius: 15,
                              color: Colors.grey[200],
                              prefixIcon: Icon(Icons.lock_outline),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              controller: confirmPasswordController,
                              hint: 'Confirm Password',
                              obscureText: true,
                              radius: 15,
                              color: Colors.grey[200],
                              prefixIcon: Icon(Icons.lock_open),
                            ),
                            const SizedBox(height: 25),
                            DefaultButton(
                              onTap: () {

                              },
                              text: 'Join Now',
                              color: ColorApp.color1,
                              textColor: Colors.white,
                              size: 18,
                              width: double.infinity,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text1: "Already have an account?",
                                  color: Colors.black54,
                                  size: 12,
                                ),
                                TextButtonCustom(
                                  text: 'Login',
                                  onTap: () {
                                    Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage(),));

                                  },
                                  color: ColorApp.color1,
                                  size: 14,
                                  padding: EdgeInsets.only(bottom: 0),
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
  }
}
