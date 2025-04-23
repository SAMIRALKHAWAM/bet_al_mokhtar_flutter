import 'package:almoktar/components/text.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/defaultButton.dart';
import '../../components/textfromfilde.dart';

class forgetPassword extends StatelessWidget {
  var emailcontroller = TextEditingController();
  var formkay = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.colorback,
      body: SingleChildScrollView(
        child: Form(
          key: formkay,
          child: Column(
            children: [
              SizedBox(height: 80),
              Image(
                image: AssetImage("assets/images/Forgot password.png"),
                height: 200,
              ),
              SizedBox(height: 15),
              CustomText(
                text1: 'Find Your Account',
                size: 30,
                font: "title",
                fontWeight: FontWeight.w100,
                color: ColorApp.color1,
              ),

              // text(text1: 'please enter your email address to search for your account ',),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 18, left: 18),
                child: CustomText(
                  text1:
                      'please enter your email address to search for your account',
                  size: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                  bottom: 18.0,
                ),
                child: CustomTextFormField(
                  hint: 'Your Email  ',
                  controller: emailcontroller,
                  color : Colors.grey[200],
                  prefixIcon: Icon(Icons.email_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter your email";
                    }
                    return null;
                  },
                ),
              ),

              DefaultButton(
                text: "Search",
                width: 130,
                height: 45,
                borderRadius: 10,
                size: 20,
                color: ColorApp.color1,
                onTap: () {
                  // Navigator.push(context,MaterialPageRoute(builder: (context) => code(email: "xcvgbhn"),));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
