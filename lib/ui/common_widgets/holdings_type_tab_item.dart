import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';

class HoldingsTypeTapItem extends StatelessWidget {
  final HoldingsType type;
  final isSelected;
  final title;
  final onClick;
  HoldingsTypeTapItem(this.type, this.isSelected, this.title, this.onClick);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: GestureDetector(
        onTap: () => onClick(type),
        child: Container(
          // width: (width - (8) - (2*16))/3 ,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.mainColor,
              border: Border.all(color: isSelected ? Colors.white : AppColors.mainColor, width: 1)
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFonts.getMediumFontSize(context),
                  height: 1.0
              ),
            ),
          ),
        ),
      ),
    );
  }
}
