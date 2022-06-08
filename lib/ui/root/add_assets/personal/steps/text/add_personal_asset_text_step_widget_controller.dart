import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'dart:math';

import 'package:wave_flutter/ui/root/holdings_screen.dart';

class AddPersonalAssetTextStepWidgetController {
  final List<PersonalAssetTypeOptionModel> _options;
  AddPersonalAssetTextStepWidgetController({required options})
      : _options = options;

  static const String LOG_TAG = 'AddPersonalAssetTextStepWidgetController';

  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [
    // AddPersonalAssetOptionModel(
    //   id: 63,
    //   type: 'text',
    //   value: 'emo',
    // ),
  ];

  final BehaviorSubject<bool> _validationController =
      BehaviorSubject.seeded(false);
  get validationStream => _validationController.stream;
  bool getValidationState() => _validationController.value;
  setValidationState(bool state) => _validationController.sink.add(state);

  bool validateAddPersonalAssetInfo(len) {
    return addPersonalAssetOptionList.length == len;
  }

  addPurchasedPrice(int id, String type, String value) {
    //validateAddPersonalAssetInfo(_options.length + 1);
    addPersonalAssetOptionList.add(
      AddPersonalAssetOptionModel(
          id: id, type: type, value: value, code: 'code'),
    );
  }

  onInputChanged(
      String value, AddPersonalAssetHoldingTypeOptionType type, int optionId) {
   

    addPersonalAssetOptionList
        .removeWhere((element) => element.id.toString() == optionId.toString());

    addPersonalAssetOptionList.add(
      AddPersonalAssetOptionModel(
        id: optionId,
        type: Utils.enumToString(type),
        value: value,
      ),
    );
    int? tempId;
    if (HoldingsScreen.typeId == 137)
      setValidationState(validateAddPersonalAssetInfo(_options.length + 1));
    else if (HoldingsScreen.typeId == 138)
      setValidationState(validateAddPersonalAssetInfo(_options.length));
    else
      setValidationState(validateAddPersonalAssetInfo(_options.length));
  }

  dispose() {
    _validationController.close();
  }
}
