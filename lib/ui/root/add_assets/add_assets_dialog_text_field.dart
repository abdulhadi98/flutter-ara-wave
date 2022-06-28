import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:wave_flutter/helper/utils.dart';

class AddAssetsDialogTextField extends StatelessWidget {
  final TextEditingController? controller;
  final isMoney;
  final isNumber;

  final TextInputType keyboardType;
  final String? hint;
  final String? labelKey;
  final double? height;
  final bool enabled;
  final FocusNode? foucsNode;
  final Function(String value)? onChanged;

  AddAssetsDialogTextField({
    required this.isMoney,
    this.controller,
    required this.keyboardType,
    this.onChanged,
    this.hint,
    this.labelKey,
    this.height,
    this.enabled = true,
    this.foucsNode,
    this.isNumber,
  });

  var maskFormatter = new MaskTextInputFormatter(
      mask: '#',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height ?? double.infinity,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextFormField(
          //  initialValue: initialValue ?? '',
          // onSubmitted: (val) {
          //   print('sub');
          //   //Utils.getFormattedStrNum(strNum)
          // },
          // onEditingComplete: () {
          //   print('comp');
          // },

          //  focusNode:foucsNode ,
          inputFormatters: isMoney
              ? [ThousandsSeparatorInputFormatter()]
              : isNumber
                  ? [
                      ThousandsSeparatorInputFormatter(),
                    ]
                  : [],
          textCapitalization: TextCapitalization.sentences,
          //  onEditingComplete: () {},
          // onSubmitted: (val) {
          //   if (isMoney && val != '' && controller != null)
          //     controller!.text = Utils.getFormattedStrNum(val);
          // },
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

          //  scrollPadding: EdgeInsets.symmetric(horizontal: 11),
          decoration: InputDecoration(
            prefix: isMoney
                ? Text(
                    '\$ ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.getSmallFontSize(context),
                      height: 1,
                    ),
                  )
                : Text(''),
            contentPadding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: 0.0,
            ),
            fillColor: AppColors.mainColor,
            filled: true,
            labelText: labelKey,
            // alignLabelWithHint: true,
            labelStyle: labelKey != null
                ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  )
                : null,
            hintText: hint,
            hintStyle: hint != null
                ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class AddAssetsDialogTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final isMoney;
  final isNumber;

  final TextInputType keyboardType;
  final String? hint;
  final String? labelKey;
  final double? height;
  final bool enabled;
  final FocusNode? foucsNode;
  final Function(String value)? onChanged;

  final String? initialValue;
  AddAssetsDialogTextFormField({
    this.initialValue,
    required this.isMoney,
    this.controller,
    required this.keyboardType,
    this.onChanged,
    this.hint,
    this.labelKey,
    this.height,
    this.enabled = true,
    this.foucsNode,
    this.isNumber,
  });

  var maskFormatter = new MaskTextInputFormatter(
      mask: '#',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height ?? double.infinity,
      alignment: Alignment.center,
      // padding: EdgeInsets.only(top: height* .008,),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: TextFormField(
          initialValue: initialValue ?? '',
          // onSubmitted: (val) {
          //   print('sub');
          //   //Utils.getFormattedStrNum(strNum)
          // },
          // onEditingComplete: () {
          //   print('comp');
          // },

          //  focusNode:foucsNode ,
          inputFormatters: isMoney
              ? [ThousandsSeparatorInputFormatter()]
              : isNumber
                  ? [
                      ThousandsSeparatorInputFormatter(),
                    ]
                  : [],
          textCapitalization: TextCapitalization.sentences,
          //  onEditingComplete: () {},
          // onSubmitted: (val) {
          //   if (isMoney && val != '' && controller != null)
          //     controller!.text = Utils.getFormattedStrNum(val);
          // },
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

          //  scrollPadding: EdgeInsets.symmetric(horizontal: 11),
          decoration: InputDecoration(
            prefix: isMoney
                ? Text(
                    '\$ ',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: AppFonts.getSmallFontSize(context),
                      height: 1,
                    ),
                  )
                : Text(''),
            contentPadding: EdgeInsets.symmetric(
              horizontal: width * .05,
              vertical: 0.0,
            ),
            fillColor: AppColors.mainColor,
            filled: true,
            labelText: labelKey,
            // alignLabelWithHint: true,
            labelStyle: labelKey != null
                ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  )
                : null,
            hintText: hint,
            hintStyle: hint != null
                ? TextStyle(
                    color: AppColors.white.withOpacity(.3),
                    fontSize: AppFonts.getSmallFontSize(context),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty

    // print(oldValue.text);

    // print(newValue.text);

    if (newValue.text.contains('.')) return newValue;

    if (oldValue.text.contains('.')) return newValue;
    if (newValue.text.length == 0) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1)
          newString = separator + newString;
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
