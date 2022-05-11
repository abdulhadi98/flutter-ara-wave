import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/select_personal_asset_type_dialog_content_bloc.dart';

abstract class SelectPersonalAssetTypeDialogContentDi {
  GetIt _getIt = GetIt.instance;
  late SelectPersonalAssetTypeDialogContentBloc addPersonalAssetBloc;

  initScreenDi(){
    addPersonalAssetBloc = _getIt<SelectPersonalAssetTypeDialogContentBloc>();
  }
}

