import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/local/app_local.dart';

Widget buildMainBtn({required context, required titleKey, required onClick, required height, btnWidth}) {
  return GestureDetector(
    onTap: onClick,
    child: Container(
      width: btnWidth,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: height * .020),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.white,
          width: 1.0,
        ),
      ),
      child: Text(
        AppLocalizations.of(context).trans(titleKey),
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFonts.getNormalFontSize(context),
          height: 1.0,
        ),
      ),
    ),
  );
}