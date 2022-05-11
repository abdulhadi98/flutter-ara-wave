import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/enums.dart';

class RootScreenController {

  final BehaviorSubject<AppMainScreens> currentScreenController = BehaviorSubject<AppMainScreens>.seeded(AppMainScreens.HOME_SCREEN);
  get currentScreenStream => currentScreenController.stream;
  AppMainScreens getCurrentScreen() => currentScreenController.value;
  setCurrentScreen(AppMainScreens screen) => currentScreenController.sink.add(screen);

  final BehaviorSubject<AppMainScreens> _previousPageController = BehaviorSubject<AppMainScreens>();
  AppMainScreens getPreviousPage() => _previousPageController.value;
  setPreviousPage(AppMainScreens screen) => _previousPageController.sink.add(screen);

  final BehaviorSubject<dynamic> _sharedDataController = BehaviorSubject<dynamic>();
  dynamic getSharedData() => _sharedDataController.value;
  setSharedData(dynamic data) => _sharedDataController.sink.add(data);

}