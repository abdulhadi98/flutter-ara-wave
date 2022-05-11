import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/local/app_local.dart';

class AddAssetDialogContentTitleWidget extends StatelessWidget {
  final String title;
  const AddAssetDialogContentTitleWidget(this.title);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final appLocal = AppLocalizations.of(context);
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical:  height* .020),
      decoration: BoxDecoration(
        color: AppColors.mainColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.white,
          fontSize: AppFonts.getNormalFontSize(context),
          height: 1.0,
        ),
      ),
    );
  }
}
