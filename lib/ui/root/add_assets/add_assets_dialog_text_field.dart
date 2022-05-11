import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';

class AddAssetsDialogTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? hint;
  final String? labelKey;
  final double? height;
  final bool enabled;
  final Function(String value)? onChanged;
  AddAssetsDialogTextField({
    this.controller,
    required this.keyboardType,
    this.onChanged,
    this.hint,
    this.labelKey,
    this.height,
    this.enabled=true,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
          autofocus: false,
          enabled: enabled,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getMediumFontSize(context),
            height: 1.1,
          ),
          keyboardType: keyboardType,
          cursorColor: AppColors.blue,
          textAlign: TextAlign.center,
          maxLines: 1,
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(horizontal: width * .02, vertical: 0.0,),
            fillColor: AppColors.mainColor,
            filled: true,
            labelText: labelKey,
            // alignLabelWithHint: true,
            labelStyle: labelKey!= null ? TextStyle(
              color: AppColors.white.withOpacity(.3),
              fontSize: AppFonts.getSmallFontSize(context),
            ): null,
            hintText: hint,
            hintStyle: hint!= null ? TextStyle(
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
}
