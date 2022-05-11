import 'package:get_it/get_it.dart';
import 'package:wave_flutter/ui/root/add_assets/private/company_shares_step_dialog_content_controller.dart';

abstract class CompanySharesStepDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late CompanySharesStepDialogContentController uiController;

  initScreenDi(){
    uiController = _getIt<CompanySharesStepDialogContentController>();
  }
}

