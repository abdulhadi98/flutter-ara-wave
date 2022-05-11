import 'dart:ffi';

import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'dart:math';


class AddPersonalAssetStepDialogContentController {
  final List<PersonalAssetTypeStep> _steps;
  final Function(List<AddPersonalAssetOptionModel> chooseOptionList, List<String>? imageUrlList) onDoneCallback;
  final AddPersonalAssetStepDialogContentBloc _addPersonalAssetStepDialogContentBloc;
  AddPersonalAssetStepDialogContentController({
    required addPersonalAssetStepDialogContentBloc,
    required params,
  }): _addPersonalAssetStepDialogContentBloc = addPersonalAssetStepDialogContentBloc,
        _steps = params["steps"],
        onDoneCallback = params["onDoneCallback"] {
    setSelectedStep(_steps.first);
  }

  static const String LOG_TAG = 'AddPersonalAssetStepDialogContentController';

  final _selectedStepController = BehaviorSubject<PersonalAssetTypeStep>();
  get selectedStepStream => _selectedStepController.stream;
  PersonalAssetTypeStep getSelectedStep() => _selectedStepController.value;
  setSelectedStep(PersonalAssetTypeStep type) => _selectedStepController.sink.add(type);

  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [];

  onChooseStepNextClicked(List<AddPersonalAssetOptionModel> chooseOptions, List<String>? imageUrlList) {
    addPersonalAssetOptionList.addAll(chooseOptions);
    moveToNextStep();
  }

  onTextStepNextClicked(List<AddPersonalAssetOptionModel> textOptionList) {
    addPersonalAssetOptionList.addAll(textOptionList);
    moveToNextStep();
  }

  onDocumentStepFinishedClicked(List<String>? imageUrlList) {
    onDoneCallback(addPersonalAssetOptionList, imageUrlList);
  }

  moveToNextStep() {
    int selectedStepIndex = _steps.indexOf(getSelectedStep());
    if(selectedStepIndex < _steps.length-1){
      setSelectedStep(_steps[selectedStepIndex+1]);
    } else onDoneCallback(addPersonalAssetOptionList, null);
  }

  dispose() {
    _selectedStepController.close();
  }
}