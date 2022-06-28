import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/private_asset_details_screen_bloc.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/private_asset_details_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/add_private_subscribed_company_dialog_content.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/add_private_subscribed_company_dialog_content_controller.dart';

import '../bloc/AddPrivateSubscribedCompanyBloc.dart';

abstract class PrivateAssetDetailsScreenDi {
  GetIt _getIt = GetIt.instance;
  late RootScreenController rootScreenController;
  late PrivateAssetDetailsScreenController uiController;
  late PrivateAssetDetailsScreenBloc privateAssetDetailsScreenBloc;
  late AddPrivateSubscribedCompanyBloc addPrivateSubscribedCompanyBloc;
  late AddPrivateSubscribedCompanyDialogContentController duiController;
  dinitScreenDi() {
    addPrivateSubscribedCompanyBloc = _getIt<AddPrivateSubscribedCompanyBloc>();
    duiController = _getIt<AddPrivateSubscribedCompanyDialogContentController>(
      param1: addPrivateSubscribedCompanyBloc,
    );
  }

  initScreenDi() {
    rootScreenController = _getIt<RootScreenController>();
    addPrivateSubscribedCompanyBloc = _getIt<AddPrivateSubscribedCompanyBloc>();
    privateAssetDetailsScreenBloc = _getIt<PrivateAssetDetailsScreenBloc>();
    uiController = _getIt<PrivateAssetDetailsScreenController>(
        param1: privateAssetDetailsScreenBloc);
  }
}
