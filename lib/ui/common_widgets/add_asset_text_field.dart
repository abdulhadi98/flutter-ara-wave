import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

import '../root/add_assets/add_assets_dialog_text_field.dart';

class AddAssetTextField extends StatelessWidget {
  final String optioType;
  final String? prefix;
  final String hintKey;
  final onChanged;
  final TextInputType keyboardType;
  //final TextEditingController? controller;
  AddAssetTextField(
      { //required this.controller,
      required this.hintKey,
      required this.onChanged,
      key,
      required this.keyboardType,
      required this.optioType,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          //   controller: ,
          inputFormatters: (optioType != 'text' && optioType != 'year')
              ? [ThousandsSeparatorInputFormatter()]
              : [],
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          enabled: true,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          // onEditingComplete: () => uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo()),
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getSmallFontSize(context),
            height: 1,
          ),
          keyboardType: keyboardType,
          cursorColor: AppColors.blue,
          textAlign: TextAlign.center,
          maxLines: 1,

          // controller: controller,
          decoration: InputDecoration(
            prefix: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Text(
                prefix!,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFonts.getSmallFontSize(context),
                  height: 1,
                ),
              ),
            ),
            // prefixIcon: Icon(Icons.attach_money_rounded,),
            // prefix: optioType == 'money'
            //     ? Text(

            //         '\$',

            //         style: TextStyle(

            //           color: AppColors.white,
            //           fontSize: AppFonts.getSmallFontSize(context),
            //           height: 1,
            //         ),
            //       )
            //     : optioType == 'percentage'
            //         ? Text(
            //             '%',
            //             style: TextStyle(
            //               color: AppColors.white,
            //               fontSize: AppFonts.getSmallFontSize(context),

            //               height: 1,
            //             ),
            //           )
            //         : Text(''),
            contentPadding: EdgeInsets.only(
              left: width * .007,
              right: width * .02,
            ),
            fillColor: AppColors.mainColor,
            filled: true,
            // labelText: labelKey,
            // alignLabelWithHint: true,
            // labelStyle: labelKey!= null ? TextStyle(
            //   color: AppColors.white.withOpacity(.3),
            //   fontSize: AppFonts.getSmallFontSize(context),
            // ): null,
            hintText: hintKey,
            hintStyle: TextStyle(
              color: AppColors.white.withOpacity(.3),
              fontSize: AppFonts.getXSmallFontSize(context),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AddAssetTextFormField extends StatelessWidget {
  final String optioType;
  final String? prefix;
  final String hintKey;
  final onChanged;
  final TextInputType keyboardType;
  final String initialValue;
  //final TextEditingController? controller;
  AddAssetTextFormField(
      { //required this.controller,

      required this.initialValue,
      required this.hintKey,
      required this.onChanged,
      key,
      required this.keyboardType,
      required this.optioType,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextFormField(
          initialValue: (optioType != 'text' && optioType != 'year')
              ? Utils.getFormattedStrNum(initialValue)
              : initialValue,
          //   controller: ,
          inputFormatters: (optioType != 'text' && optioType != 'year')
              ? [ThousandsSeparatorInputFormatter()]
              : [],
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          enabled: true,
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          // onEditingComplete: () => uiController.setValidateAddPersonalAssetInfo(uiController.validateAddPersonalAssetInfo()),
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getSmallFontSize(context),
            height: 1,
          ),
          keyboardType: keyboardType,
          cursorColor: AppColors.blue,
          textAlign: TextAlign.center,
          maxLines: 1,

          // controller: controller,
          decoration: InputDecoration(
            prefix: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Text(
                prefix!,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppFonts.getSmallFontSize(context),
                  height: 1,
                ),
              ),
            ),
            // prefixIcon: Icon(Icons.attach_money_rounded,),
            // prefix: optioType == 'money'
            //     ? Text(

            //         '\$',

            //         style: TextStyle(

            //           color: AppColors.white,
            //           fontSize: AppFonts.getSmallFontSize(context),
            //           height: 1,
            //         ),
            //       )
            //     : optioType == 'percentage'
            //         ? Text(
            //             '%',
            //             style: TextStyle(
            //               color: AppColors.white,
            //               fontSize: AppFonts.getSmallFontSize(context),

            //               height: 1,
            //             ),
            //           )
            //         : Text(''),
            contentPadding: EdgeInsets.only(
              left: width * .007,
              right: width * .02,
            ),
            fillColor: AppColors.mainColor,
            filled: true,
            // labelText: labelKey,
            // alignLabelWithHint: true,
            // labelStyle: labelKey!= null ? TextStyle(
            //   color: AppColors.white.withOpacity(.3),
            //   fontSize: AppFonts.getSmallFontSize(context),
            // ): null,
            hintText: hintKey,
            hintStyle: TextStyle(
              color: AppColors.white.withOpacity(.3),
              fontSize: AppFonts.getXSmallFontSize(context),
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
