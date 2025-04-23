import 'package:flutter/material.dart';

class TextButtonCustom extends StatelessWidget {
  const TextButtonCustom({
    Key? key,
    required this.text,
    required this.onTap,
    this.color = Colors.black87,
    this.size = 15,
    this.font = 'text normal',
    this.fontWeight = FontWeight.w400,
    this.backgroundColor = const Color(0xFFffffff),
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical:0),
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final String font;
  final FontWeight fontWeight;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: TextStyle(
            fontSize: size,
            fontWeight: fontWeight,
            fontFamily: font,
            color: color,
          ),
        ),
      ),
    );
  }
}
