import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';

class SelectorPersonalAssetGridItemWidget extends StatelessWidget {
  final bool isSelected;
  final String title;
  const SelectorPersonalAssetGridItemWidget({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * .020),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        border: Border.all(color: isSelected ? Colors.white : AppColors.mainColor, width: .5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFonts.getMediumFontSize(context),
          height: 1.0,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
