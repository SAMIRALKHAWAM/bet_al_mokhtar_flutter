import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/text.dart';
import 'package:flutter/material.dart';
import '../../components/colors.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';

class code extends StatelessWidget {
  code({required this.email});
  String email;
  var codecontroller = TextEditingController();
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
              SizedBox(height: 100),
              Image(
                image: AssetImage("assets/images/Forgot password.png"),
                height: 200,
              ),
              SizedBox(height: 15),
              CustomText(
                text1: 'Enter Code ',
                size: 30,
                font: "title",
                fontWeight: FontWeight.w100,
                color: ColorApp.color1,
              ),

              // text(text1: 'please enter your email address to search for your account ',),
              SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text1: 'please enter Code sent to ${email}  ',
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
                  hint: 'Code*',
                  controller: codecontroller,
                  color : Colors.grey[200],

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please enter code";
                    }
                    return null;
                  },
                ),
              ),
              DefaultButton(
                onTap: () {},
                text: "Submit",
                width: 130,
                height: 45,
                borderRadius: 10,
                size: 20,
                color: ColorApp.color1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text1: "Not Receive Code?",
                        size: 14,
                        fontWeight: FontWeight.w100,
                        color: Colors.black45,
                      ),
                      TextButtonCustom(text: "Resend", onTap: () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
