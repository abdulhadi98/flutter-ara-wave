import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:wave_flutter/di/register/registration_di_container.dart';
import 'package:wave_flutter/helper/app_constant.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/local/app_local.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'helper/app_colors.dart';
import 'ui/intro/splash_screen.dart';

Future<void> main() async {
  RegistrationDiContainer().registerDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.getFontFamily(GetIt.I<DataStore>().lang ?? ""),
        canvasColor: Colors.white,
        primaryColor: AppColors.mainColor,
      ),
      supportedLocales: <Locale>[const Locale('ar'), const Locale('en')],
      localizationsDelegates: [const AppLocalizationsDelegate(), GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
      localeResolutionCallback: (Locale? locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (locale != null) if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: InitPage(),
    );
  }
}

class InitPage extends StatelessWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstant.screenSize = MediaQuery.of(context).size;
    print('InitPage : width= ${AppConstant.screenSize.width} height= ${AppConstant.screenSize.height}');
    AppConstant.context = context;
    return SplashScreen();
  }
}
