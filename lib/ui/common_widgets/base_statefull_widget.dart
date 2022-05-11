import 'package:flutter/material.dart';
import 'package:wave_flutter/local/app_local.dart';

class BaseStateFullWidget extends StatefulWidget {

  @override
  BaseStateFullWidgetState createState() => BaseStateFullWidgetState();

  BaseStateFullWidget({key}): super(key: key);
}

class BaseStateFullWidgetState<T extends BaseStateFullWidget> extends State<T> with TickerProviderStateMixin {

  late MediaQueryData mediaQuery;
  late double width;
  late double height;
  late String lang;
  late AppLocalizations appLocal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      mediaQuery = MediaQuery.of(context);
      width = MediaQuery.of(context).size.width;
      height = MediaQuery.of(context).size.height;
      lang = AppLocalizations.of(context).locale.languageCode;
      appLocal = AppLocalizations.of(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}