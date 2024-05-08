
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color.fromRGBO(31, 73, 125, 1);
  static const Color secondaryColor= Color(0xFF6FDB4F);
  static const Color tertiaryColor = Color(0xFFFF0266);

  // static const Color primaryColor = Color(0xFF459ACC);
  // static const Color primaryColor = Color(0xFF377297);

  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);

  static const Color errorColor = Color(0xFFD32F2F);
}

class Fonts {
  static const double titleFont = 52.0;
  static const double titleShortcuts = 24.0;
  static const double subtitle = 18.0;
  
}

class AppNames {
  static const String appName = 'EDI Dash';
}

class AppComponents {
  static AppBar appBar(
    Widget title, {
      Widget? iconButton
    }
  ) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: title,
      foregroundColor: AppColors.whiteColor,
    );
  }
}