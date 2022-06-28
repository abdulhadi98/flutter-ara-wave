import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/local/app_local.dart';
import 'package:wave_flutter/ui/root/add_assets/loading_indicator.dart';

class AddAssetDialog extends StatelessWidget {
  final Widget contentWidget;
  final String titleKey;
  final ValueStream<bool>? loadingStream;
  const AddAssetDialog(
      {required this.contentWidget,
      required this.titleKey,
      this.loadingStream});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    AppLocalizations appLocal = AppLocalizations.of(context);
    return StreamBuilder<bool>(
        initialData: false,
        stream: loadingStream,
        builder: (context, loadingSnapshot) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: IgnorePointer(
              ignoring: loadingSnapshot.data ?? false,
              child: Stack(
                children: [
                  Positioned(
                    top: width * .075 / 2,
                    right: width * .075 / 2,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: height * .025),
                          Text(
                            appLocal.trans(titleKey),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppFonts.getLargeFontSize(context),
                              height: 1.0,
                            ),
                          ),
                          SizedBox(height: height * .020),
                          Container(
                            margin: const EdgeInsets.all(1),
                            padding:
                                EdgeInsets.symmetric(horizontal: width * .08),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: height ),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: contentWidget),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.gray, width: .5),
                          shape: BoxShape.circle,
                          color: AppColors.mainColor,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.gray,
                          size: width * .055,
                        ),
                      ),
                    ),
                  ),
                  if (loadingSnapshot.data ?? false)
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                      child: LoadingIndicator(),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
