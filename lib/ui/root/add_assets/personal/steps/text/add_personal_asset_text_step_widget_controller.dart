import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'dart:math';


class AddPersonalAssetTextStepWidgetController {
  final List<PersonalAssetTypeOptionModel> _options;
  AddPersonalAssetTextStepWidgetController({required options}): _options = options;

  static const String LOG_TAG = 'AddPersonalAssetTextStepWidgetController';

  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [];

  final BehaviorSubject<bool> _validationController = BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool state) => _validationController.sink.add(state);

  bool validateAddPersonalAssetInfo() {
    return addPersonalAssetOptionList.length == _options.length;
  }

  onInputChanged(String value, AddPersonalAssetHoldingTypeOptionType type, int optionId) {
    addPersonalAssetOptionList.removeWhere((element) => element.id.toString() == optionId.toString());
    addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
      id: optionId,
      type: Utils.enumToString(type),
      value: value,
    ),);
    setValidationState(validateAddPersonalAssetInfo());
  }

  dispose() {
    _validationController.close();
  }
}