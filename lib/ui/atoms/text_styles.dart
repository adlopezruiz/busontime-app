import 'package:bot_main_app/utils/constants.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.secondaryGrey,
  );

  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlack,
  );

  static const subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlack,
  );

  static const body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryBlack,
  );

  static ShaderMask textWithTransparency({
    required String text,
    required double fontSize,
    TextAlign? textAlign,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.white, Colors.white.withOpacity(0.5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}
