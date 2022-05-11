import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';

Widget buildCardItem({required title, required value, required context, required width, valueTextColor = Colors.white,}){
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppFonts.getXSmallFontSize(context),
              color: AppColors.white,
              height: 1.0,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: AppFonts.getXSmallFontSize(context),
              color: valueTextColor,
              height: 1.0,
            ),
          ),
          // SizedBox(width: width* .05),
        ],
      ),
      Divider(thickness: .75, color: Colors.black,),
    ],
  );
}