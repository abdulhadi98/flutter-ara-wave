import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/utils.dart';

Widget buildHeaderComponents({
  titleWidget,
  logoTitleKey,
  context,
  appLocal,
  width,
  height,
  isAddProgressExist = false,
  addEditTitleKey = 'new_asset',
  addEditIcon = 'assets/icons/ic_add.svg',
  onAddEditClick,
  totalTextKey = 'total_net_balance_in_usd',
  isSecondRowVisible = true,
  String? netWorth,
  String? growth,
}) {
  return Column(
    children: [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.019,
                  horizontal: width * .005,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(width * 0.019),
                ),
                child: titleWidget,
              ),
            ),
            SizedBox(width: width * .015),
            Container(
              width: width * .26,
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(
              //     vertical: height * 0.02, horizontal: width * .020),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(width * 0.019),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (logoTitleKey != '')
                    Text(
                      appLocal.trans(logoTitleKey), //TODO
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: Colors.white,
                      ),
                    ),
                  if (logoTitleKey == '')
                    Utils.buildImage(
                      url: 'assets/images/logo.png',
                      width: logoTitleKey != '' ? width * .06 : width * .1,
                      height: logoTitleKey != '' ? width * .06 : width * .1,
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (isSecondRowVisible)
        SizedBox(
          height: width * .015,
        ),
      if (isSecondRowVisible)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    bottom: height * 0.01,
                    left: width * .03,
                    right: width * .027,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(width * 0.019),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: width* .03),
                      //   child: SvgPicture.asset(
                      //     'assets/icons/ic_up_arrow.svg',
                      //     width: width* .04,
                      //     height: width* .04,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      // SizedBox(width: width* .04),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            //  top: height * 0.02,
                            bottom: height * 0.005,
                            left: width * .013,
                            right: width * .01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  growth == null
                                      ? SizedBox()
                                      : growth.contains('+') || (!growth.contains('+') && !growth.contains('-'))
                                          ? Icon(
                                              Icons.keyboard_double_arrow_up,
                                              color: AppColors.blue,
                                              size: width * .07,
                                            )
                                          : Icon(
                                              Icons.keyboard_double_arrow_down,
                                              color: Colors.red,
                                              size: width * .07,
                                            ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(left: width * 0.007),
                                      child: Text(
                                        netWorth ?? '',
                                        style: TextStyle(
                                          fontSize: AppFonts.getXLargeFontSize(context),
                                          color: Colors.white,
                                          height: 1.0,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width * .02),
                                  Text(
                                    growth ?? '',
                                    style: TextStyle(
                                      fontSize: AppFonts.getSmallFontSize(context),
                                      color: AppColors.blue,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * .010),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.01),
                                child: Text(
                                  appLocal.trans(totalTextKey),
                                  style: TextStyle(
                                    fontSize: AppFonts.getSmallFontSize(context),
                                    color: Colors.white.withOpacity(.9),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAddProgressExist && onAddEditClick != null) SizedBox(width: width * .015),
              if (isAddProgressExist && onAddEditClick != null)
                GestureDetector(
                  onTap: onAddEditClick,
                  child: Container(
                    width: width * .26,
                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * .025),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(width * 0.019),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          addEditIcon,
                          width: width * .09,
                          height: width * .09,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: height * .012,
                        ),
                        Text(
                          appLocal.trans(addEditTitleKey),
                          style: TextStyle(
                            fontSize: AppFonts.getXSmallFontSize(context),
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
    ],
  );
}

Widget buildHeaderComponentsHome({
  titleWidget,
  logoTitleKey,
  context,
  appLocal,
  width,
  height,
  isAddProgressExist = false,
  addEditTitleKey = 'new_asset',
  addEditIcon = 'assets/icons/ic_add.svg',
  onAddEditClick,
  totalTextKey = 'total_net_balance_in_usd',
  isSecondRowVisible = true,
  String? netWorth,
  String? growth,
}) {
  return Column(
    children: [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.013,
                  horizontal: width * .005,
                ),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(width * 0.019),
                ),
                child: titleWidget,
              ),
            ),
            SizedBox(width: width * .015),
            Container(
              width: width * .26,
              alignment: Alignment.center,
              // padding: EdgeInsets.symmetric(
              //     vertical: height * 0.02, horizontal: width * .020),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(width * 0.019),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (logoTitleKey != '')
                    Text(
                      appLocal.trans(logoTitleKey), //TODO
                      style: TextStyle(
                        fontSize: AppFonts.getMediumFontSize(context),
                        color: Colors.white,
                      ),
                    ),
                  if (logoTitleKey == '')
                    Utils.buildImage(
                      url: 'assets/images/logo.png',
                      width: logoTitleKey != '' ? width * .06 : width * .1,
                      height: logoTitleKey != '' ? width * .06 : width * .1,
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (isSecondRowVisible)
        SizedBox(
          height: width * .015,
        ),
      if (isSecondRowVisible)
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(
                    top: height * 0.02,
                    bottom: height * 0.01,
                    left: width * .03,
                    right: width * .027,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor,
                    borderRadius: BorderRadius.circular(width * 0.019),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: width* .03),
                      //   child: SvgPicture.asset(
                      //     'assets/icons/ic_up_arrow.svg',
                      //     width: width* .04,
                      //     height: width* .04,
                      //     fit: BoxFit.cover,
                      //   ),
                      // ),
                      // SizedBox(width: width* .04),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            //  top: height * 0.02,
                            bottom: height * 0.005,
                            left: width * .013,
                            right: width * .01,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      netWorth ?? '',
                                      style: TextStyle(
                                        fontSize: AppFonts.getXXLargeFontSize(context),
                                        color: Colors.white,
                                        height: 1.0,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(width: width * .04),
                                  Text(
                                    growth ?? '',
                                    style: TextStyle(
                                      fontSize: AppFonts.getMediumFontSize(context),
                                      color: AppColors.blue,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height * .010),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.01),
                                child: Text(
                                  'appLocal.trans(totalTextKey)',
                                  style: TextStyle(
                                    fontSize: AppFonts.getXSmallFontSize(context),
                                    color: Colors.white.withOpacity(.35),
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAddProgressExist && onAddEditClick != null) SizedBox(width: width * .015),
              if (isAddProgressExist && onAddEditClick != null)
                GestureDetector(
                  onTap: onAddEditClick,
                  child: Container(
                    width: width * .26,
                    padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * .025),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(width * 0.019),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          addEditIcon,
                          width: width * .09,
                          height: width * .09,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: height * .012,
                        ),
                        Text(
                          appLocal.trans(addEditTitleKey),
                          style: TextStyle(
                            fontSize: AppFonts.getXSmallFontSize(context),
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
    ],
  );
}
