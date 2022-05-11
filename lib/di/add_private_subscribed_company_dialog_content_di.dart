import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/AddPrivateSubscribedCompanyBloc.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/add_private_subscribed_company_dialog_content_controller.dart';

abstract class AddPrivateSubscribedDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late AddPrivateSubscribedCompanyDialogContentController uiController;
  late AddPrivateSubscribedCompanyBloc addPrivateSubscribedCompanyBloc;

  initScreenDi() {
    addPrivateSubscribedCompanyBloc = _getIt<AddPrivateSubscribedCompanyBloc>();
    uiController = _getIt<AddPrivateSubscribedCompanyDialogContentController>(
        param1: addPrivateSubscribedCompanyBloc,
    );
  }
}

