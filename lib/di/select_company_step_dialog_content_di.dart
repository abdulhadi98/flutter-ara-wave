import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/AddPrivateAssetManuallyBloc.dart';
import 'package:wave_flutter/bloc/select_company_step_dialog_bloc.dart';
import 'package:wave_flutter/ui/root/add_assets/private/manually/add_private_asset_manually_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/select_company_step_dialog_content_controller.dart';

abstract class SelectCompanyStepDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late SelectCompanyStepDialogContentController uiController;
  late SelectCompanyStepDialogBloc selectCompanyStepDialogBloc;

  initScreenDi(){
    selectCompanyStepDialogBloc = _getIt<SelectCompanyStepDialogBloc>();
    uiController = _getIt<SelectCompanyStepDialogContentController>(param1: selectCompanyStepDialogBloc,);
  }
}

