import 'dart:ui';

import 'package:flutter/material.dart';

showAddAssetDialog2({
  required context,
  required padding,
  required Widget dialogContent,
  //   required popupHeight
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                //      height: popupHeight,
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: padding,
                  child: Container(child: dialogContent),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

showAddAssetDialog(
    {required context,
    required padding,
    required Widget dialogContent,
    required popupHeight}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: padding,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: popupHeight),
                      child: dialogContent),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
