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
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: padding,
          child: dialogContent,
        );
      });
}