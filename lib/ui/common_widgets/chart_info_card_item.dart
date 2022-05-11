import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

class ChartInfoCardItem extends BaseStateFullWidget {
  final title;
  final value;
  final bottomLabel;
  final itemHeight;
  ChartInfoCardItem({this.title, this.value, this.bottomLabel, this.itemHeight,});

  @override
  _ChartInfoCardItemState createState() => _ChartInfoCardItemState();
}

class _ChartInfoCardItemState extends BaseStateFullWidgetState<ChartInfoCardItem> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Expanded(
      child: Container(
        height: widget.itemHeight??height* .16,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: width* .025),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FittedBox(
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: AppFonts.getMediumFontSize(context),
                      color: AppColors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // SizedBox(height: height* .025),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Center(
                child: FittedBox(
                  child: Text(
                    widget.value,
                    style: TextStyle(
                      fontSize: AppFonts.getNormalFontSize(context),
                      color: AppColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // if(widget.bottomLabel!=null) SizedBox(height: height* .008,),
            if(widget.bottomLabel!=null) Text(
              widget.bottomLabel,
              style: TextStyle(
                fontSize: AppFonts.getXXXSmallFontSize(context),
                color: AppColors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            if(widget.bottomLabel!=null) SizedBox(height: height* .03),
          ],
        ),
      ),
    );
  }
}
