import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/common_widgets/show_date_picker.dart';

class DatePickerPlaceholderWidget extends BaseStateFullWidget {
  final String hint;
  final Function(String date) onDatedPicked;
  final Color? color;
  DatePickerPlaceholderWidget({
    this.color,
    required this.hint,
    required this.onDatedPicked,
    Key? key,
  }) : super(key: key);

  @override
  BaseStateFullWidgetState<DatePickerPlaceholderWidget> createState() => _DatePickerPlaceholderWidgetState();
}

class _DatePickerPlaceholderWidgetState extends BaseStateFullWidgetState<DatePickerPlaceholderWidget> {
  final BehaviorSubject<DateTime?> _purchaseDateController = BehaviorSubject<DateTime?>();
  get purchaseDateStream => _purchaseDateController.stream;
  DateTime? getPurchaseDate() => _purchaseDateController.valueOrNull;
  setPurchaseDate(DateTime? dateTime) => _purchaseDateController.sink.add(dateTime);

  @override
  void dispose() {
    _purchaseDateController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime?>(
        stream: purchaseDateStream,
        builder: (context, dateTimeSnapshot) {
          return GestureDetector(
            onTap: () async {
              DateTime? pickedDateTime = await showCustomDatePicker(
                initialDate: dateTimeSnapshot.data,
                context: context,
                locale: appLocal.locale,
              );
              if (pickedDateTime != null) widget.onDatedPicked(pickedDateTime.toString().substring(0, 10));
              setPurchaseDate(pickedDateTime);
            },
            child: Container(
              height: height * .07,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                dateTimeSnapshot.data == null ? widget.hint : dateTimeSnapshot.data.toString().substring(0, 10),
                style: TextStyle(
                  color: (dateTimeSnapshot.data != null || widget.color != null)
                      ? Colors.white
                      : widget.color != null
                          ? widget.color
                          : Colors.white.withOpacity(.65),
                  //fontSize: AppFonts.getSmallFontSize(context),
                  fontSize: AppFonts.getXSmallFontSize(context),
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        });
  }
}
