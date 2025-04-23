import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.onTap,
    this.height = 60,
    this.width = 120,
    this.borderRadius = 20,
    this.size = 15,
    this.color = Colors.indigo,
    this.text = '',
    this.textColor = Colors.white,
    this.icon,
    this.iconColor = Colors.black87,
    this.iconSize = 20,
    this.fontWeight = FontWeight.bold,
    this.fontFamily = 'text normal',
  }) : super(key: key);

  /// Callback when button is tapped
  final VoidCallback onTap;

  /// Height and width of the button
  final double height;
  final double width;

  /// Border radius
  final double borderRadius;

  /// Font settings
  final double size;
  final String text;
  final Color textColor;
  final String fontFamily;
  final FontWeight fontWeight;

  /// Button background color
  final Color color;

  /// Optional icon settings
  final IconData? icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    // Define what will be shown inside the button
    Widget content;

    if (text.isNotEmpty && icon == null) {
      // Text only
      content = Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: fontWeight,
          color: textColor,
          fontFamily: fontFamily,
        ),
      );
    } else if (text.isEmpty && icon != null) {
      // Icon only
      content = Icon(icon, color: iconColor, size: iconSize);
    } else {
      // Text + Icon
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: iconSize),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: size,
              fontWeight: fontWeight,
              color: textColor,
              fontFamily: fontFamily,
            ),
          ),
        ],
      );
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: content,
      ),
    );
  }
}
