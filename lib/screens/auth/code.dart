import 'package:almoktar/components/defaultButton.dart';
import 'package:almoktar/components/text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../components/colors.dart';
import '../../components/textButton.dart';
import '../../components/textfromfilde.dart';

class CodePage extends StatelessWidget {
  CodePage({required this.email, super.key});

  final String email;
  final codecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.colorback,
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Image(
                image: AssetImage("assets/images/Forgot password.png"),
                height: 200,
              ),
              const SizedBox(height: 15),
              CustomText(
                text1: 'enter_code'.tr(),
                size: 30,
                font: "title",
                fontWeight: FontWeight.w100,
                color: ColorApp.color1,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: CustomText(
                  text1: 'enter_code_desc'.tr() + ' ${email}',
                  size: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                child: CustomTextFormField(
                  hint: 'code_hint'.tr(),
                  controller: codecontroller,
                  color: Colors.grey[200],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please_enter_code".tr();
                    }
                    return null;
                  },
                ),
              ),
              DefaultButton(
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    // handle submit
                  }
                },
                text: "submit".tr(),
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
                        text1: "not_receive_code".tr(),
                        size: 14,
                        fontWeight: FontWeight.w100,
                        color: Colors.black45,
                      ),
                      TextButtonCustom(
                        text: "resend".tr(),
                        onTap: () {},
                      ),
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
