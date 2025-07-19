import 'package:almoktar/components/text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../components/colors.dart';
import '../../components/defaultButton.dart';
import '../../components/textfromfilde.dart';

class ForgetPassword extends StatelessWidget {
  ForgetPassword({super.key});

  final emailcontroller = TextEditingController();
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
              const SizedBox(height: 80),
              const Image(
                image: AssetImage("assets/images/Forgot password.png"),
                height: 200,
              ),
              const SizedBox(height: 15),
              CustomText(
                text1: 'find_account'.tr(),
                size: 30,
                font: "title",
                fontWeight: FontWeight.w100,
                color: ColorApp.color1,
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 18, left: 18),
                child: CustomText(
                  text1: 'find_account_desc'.tr(),
                  size: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                  bottom: 18.0,
                ),
                child: CustomTextFormField(
                  hint: 'your_email'.tr(),
                  controller: emailcontroller,
                  color: Colors.grey[200],
                  prefixIcon: const Icon(Icons.email_rounded),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "please_enter_email".tr();
                    }
                    return null;
                  },
                ),
              ),
              DefaultButton(
                text: "search".tr(),
                width: 130,
                height: 45,
                borderRadius: 10,
                size: 20,
                color: ColorApp.color1,
                onTap: () {
                  if (formkey.currentState!.validate()) {
                    // هنا تضع كود الانتقال لصفحة الكود مع الإيميل:
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => CodePage(email: emailcontroller.text)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
