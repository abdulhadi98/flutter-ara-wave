import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';

Widget buildDialogInputField(context, width, controller, keyboardType, {hintKey, labelKey, height, obscureText=false}) {
  return Container(
    height: height??double.infinity,
    alignment: Alignment.center,
    // padding: EdgeInsets.only(top: height* .008,),
    decoration: BoxDecoration(
      color: AppColors.mainColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        obscureText: obscureText,
        autofocus: false,
        enabled: true,
        onChanged: (v) {
          if (v != null) {
          }
        },
        textInputAction: TextInputAction.next,
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFonts.getMediumFontSize(context),
          height: 1.1,
        ),
        keyboardType: keyboardType,
        cursorColor: AppColors.blue,
        textAlign: TextAlign.left,
        maxLines: 1,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
          EdgeInsets.symmetric(horizontal: width * .05, vertical: 0.0,),
          fillColor: AppColors.mainColor,
          filled: true,
          labelText: labelKey,
          // alignLabelWithHint: true,
          labelStyle: labelKey!= null ? TextStyle(
            color: AppColors.white.withOpacity(.3),
            fontSize: AppFonts.getSmallFontSize(context),
          ): null,
          hintText: hintKey,
          hintStyle: hintKey!= null ? TextStyle(
            color: AppColors.white.withOpacity(.3),
            fontSize: AppFonts.getSmallFontSize(context),
          ): null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    ),
  );
}
