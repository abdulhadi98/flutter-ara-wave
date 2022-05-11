import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/add_asset_dialog_content_controller.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/company_info_step_dialog_content_controller.dart';

abstract class CompanyInfoStepDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late CompanyInfoStepDialogContentController uiController;

  initScreenDi(){
    uiController = _getIt<CompanyInfoStepDialogContentController>();
  }
}

