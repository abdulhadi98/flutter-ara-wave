import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/add_personal_asset_document_step_widget_bloc.dart';
import 'package:wave_flutter/bloc/select_personal_asset_type_dialog_content_bloc.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/image/add_personal_asset_document_step_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/text/add_personal_asset_text_step_widget_controller.dart';

abstract class AddPersonalAssetDocumentStepWidgetDi {
  GetIt _getIt = GetIt.instance;
  late AddPersonalAssetDocumentStepWidgetController uiController;
  late AddPersonalAssetDocumentStepWidgetBloc addPersonalAssetDocumentStepWidgetBloc;

  initScreenDi(){
    addPersonalAssetDocumentStepWidgetBloc = _getIt<AddPersonalAssetDocumentStepWidgetBloc>();
    uiController = _getIt<AddPersonalAssetDocumentStepWidgetController>(
      param1: addPersonalAssetDocumentStepWidgetBloc,
    );
  }
}

