import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/local/app_local.dart';

class ErrorMessageWidget extends StatelessWidget {
  final String messageKey;
  final image;
  final reloadFun;
  ErrorMessageWidget({required this.messageKey, required this.image, this.reloadFun,});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppLocalizations appLocal = AppLocalizations.of(context);
    return Material(
      color: Colors.transparent,
      child: Container(
        // height: double.infinity,
        alignment: Alignment.center,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width* .12, vertical: 16,),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image.asset(
                //   image,
                //   // height: width* .75,
                //   width: width* .75,
                //   fit: BoxFit.fitHeight,
                // ),
                SizedBox(height: 24),
                if(reloadFun!=null) Text(
                  'Oops!',
                  style: TextStyle(
                    height: 1.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    fontSize: AppFonts.getXXXLargeFontSize(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                if(reloadFun!=null) SizedBox(height: 8),
                Text(
                  appLocal.trans(messageKey),
                  style: TextStyle(
                    height: 1.4,
                    color: Colors.white,
                    fontSize: AppFonts.getMediumFontSize(context),
                  ),
                  textAlign: TextAlign.center,
                ),
                if(reloadFun!=null) SizedBox(height: 32,),
                if(reloadFun!=null) OutlinedButton(
                  onPressed: reloadFun,
                  child: Text(
                    appLocal.trans('try_again'),
                    style: TextStyle(
                      fontSize: AppFonts.getSmallFontSize(context),
                      color: Colors.grey.shade900,
                    ),
                  ),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(AppColors.mainColor.withOpacity(.05)),
                    side: MaterialStateProperty.all(BorderSide(
                      color: AppColors.mainColor,
                      width: .5,
                    )),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: 32,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}