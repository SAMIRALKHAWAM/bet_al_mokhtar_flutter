import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.hint,
    this.color = Colors.grey,
    this.radius = 30,
    this.maxLength,
    this.textColor = Colors.black87,
    this.fontSize = 14,
    this.cursorHeight,
    this.keyboardType,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
    this.onSuffixPressed,
    this.text,
  }) : super(key: key);

  final String hint;
  final Color? color;
  final Color? textColor;
  final int? maxLength;
  final double radius;
  final double? fontSize;
  final double? cursorHeight;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool readOnly;
  final VoidCallback? onSuffixPressed;
  final VoidCallback? onTap;
   final String? text;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,

      readOnly: readOnly,
      onTap: onTap,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLength: maxLength,
      cursorColor: textColor,
      cursorHeight: cursorHeight,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        labelText: text,
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
        hintText: hint,
        hintStyle: TextStyle(color: textColor),
        suffixIcon: suffixIcon != null
            ? GestureDetector(
          onTap: onSuffixPressed,
          child: suffixIcon,
        )
            : null,
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
