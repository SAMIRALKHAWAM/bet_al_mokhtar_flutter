import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text1,
    this.fontWeight = FontWeight.w500,
    this.color = Colors.black87,
    this.size = 14,
    this.font = 'text normal',
    this.themestyle,
  }) : super(key: key);

  final String text1;
  final double? size;
  final FontWeight? fontWeight;
  final Color? color;
  final String? font;
  final TextStyle? themestyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text1,
      style: themestyle ??
          TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            color: color,
            fontFamily: font,
          ),
    );
  }
}
