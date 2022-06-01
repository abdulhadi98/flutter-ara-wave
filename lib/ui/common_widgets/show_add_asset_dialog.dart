import 'dart:ui';

import 'package:flutter/material.dart';

showAddAssetDialog({
  required context,
  required padding,
  required Widget dialogContent,
}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: padding,
            child: dialogContent,
          ),
        );
      });
}
