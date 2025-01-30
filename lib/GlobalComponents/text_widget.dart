import 'package:flutter/material.dart';
import 'package:mobile_pos/constant.dart';

class TextWidget extends StatelessWidget {
  final String title;
  final double txtSize;
  final Color txtColor;
  final Function()? onpress;
  final int? maxLines;
  final FontWeight? fontWeight;
  const TextWidget({
    super.key,
    //super.key,
    required this.title,
    this.maxLines = 1,
    this.txtSize = 12,
    this.txtColor = AppColors.darkColor,
    this.fontWeight = FontWeight.w500,
    this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Text(
        title,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: txtSize,
          fontWeight: fontWeight,
          color: txtColor,
        ),
      ),
    );
  }
}
