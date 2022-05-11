import 'package:flutter/material.dart';
import 'package:wave_flutter/helper/app_colors.dart';

showYearPicker({
  required BuildContext context,
  DateTime? initialDate,
  required Function(DateTime dateTime) onDatePicked,
}) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select Year", style: TextStyle(color: Colors.white,),),
        backgroundColor: AppColors.mainColor,
        content: Container( // Need to use container to add size constraint.
          width: 300,
          height: 300,
          color: AppColors.mainColor,
          child: Theme(
            data: ThemeData.dark(),
            child: YearPicker(
              firstDate: DateTime(DateTime.now().year - 100, 1),
              lastDate: DateTime.now(),
              initialDate: DateTime.now(),
              selectedDate: initialDate??DateTime.now(),
              onChanged: (DateTime dateTime) {
                onDatePicked(dateTime);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      );
    },
  );
}

Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required Locale locale,
  DateTime? initialDate,
}) {
  return showDatePicker(
    context: context,
    locale: locale,
    initialDate: initialDate??DateTime.now(),
    firstDate: DateTime(DateTime.now().year - 100, 1),
    lastDate: DateTime(DateTime.now().year + 100, 1),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark(),
        child: child!,
      );
    },
  );
}