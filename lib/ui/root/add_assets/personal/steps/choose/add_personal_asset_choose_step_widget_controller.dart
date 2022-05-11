import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_choose_step_widget_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/choose_step_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'dart:math';

import 'package:wave_flutter/services/data_resource.dart';

class AddPersonalAssetChooseStepWidgetController {
  final AddPersonalAssetChooseStepWidgetBloc _addPersonalAssetChooseStepBloc;
  AddPersonalAssetChooseStepWidgetController(
      {required addPersonalAssetChooseStepBloc})
      : _addPersonalAssetChooseStepBloc = addPersonalAssetChooseStepBloc;

  static const String LOG_TAG = 'AddPersonalAssetChooseStepWidgetController';

  List<AddPersonalAssetOptionModel> addPersonalAssetOptionList = [];

  final BehaviorSubject<bool> _loadingController =
      BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  final _chooseStepModelController = BehaviorSubject<ChooseStepModel?>();
  get stepsStream => _chooseStepModelController.stream;
  ChooseStepModel? getChooseStepModel() => _chooseStepModelController.value;
  setChooseStepModel(ChooseStepModel? item) =>
      _chooseStepModelController.sink.add(item);

  initSteps(List<PersonalAssetTypeOptionModel> children) {
    int maxStepCount =
        children.map((element) => element.step).cast<int>().reduce(max);
    List<PersonalAssetTypeStep> steps = [];
    for (int i = 1; i <= maxStepCount; i++) {
      List<PersonalAssetTypeOptionModel> options =
          children.where((element) => element.step == i).toList();
      if (options.isEmpty) continue;
      options.sort((a, b) => a.order.compareTo(b.order));

      PersonalAssetTypeStep step = PersonalAssetTypeStep(
        options: options,
      );
      steps.add(step);
    }

    setChooseStepModel(ChooseStepModel(
      type: AddPersonalAssetChooseStepType.steps,
      steps: steps,
    ));
  }

  initOptionValues(PersonalAssetTypeOptionModel option) {
    setChooseStepModel(ChooseStepModel(
      type: AddPersonalAssetChooseStepType.optionValues,
      option: option,
    ));
  }

  onNextClicked({
    required PersonalAssetTypeOptionValues optionValue,
    required Function(List<AddPersonalAssetOptionModel> chooseOptionList,
            List<String>? imageUrlList)
        onDoneCallback,
  }) {
    setLoadingState(true);
    addPersonalAssetOptionList.add(AddPersonalAssetOptionModel(
      id: optionValue.typeOptionId,
      type: Utils.enumToString(AddPersonalAssetHoldingTypeOptionType.choose),
      value: optionValue.id.toString(),
    ));
    print(
        '/////////////////tepeId = ${optionValue.id} /////////////////\n\n\n///////////////////');

    int typeId;
    int? optionValueId;
    if (optionValue.typeOptionId != -1) {
      typeId = optionValue.typeOptionId;
      optionValueId = optionValue.id;
    } else {
      typeId = optionValue.id;
    }

    _addPersonalAssetChooseStepBloc.fetchPersonalAssetTypeOptionChildren(
      typeId: typeId,
      optionValueId: optionValueId,
      onData: (children) {
        setLoadingState(false);
        if (children.isNotEmpty) {
          if (children.first.typeEnum ==
              AddPersonalAssetHoldingTypeOptionType.choose) {
            initOptionValues(children.first);
          } else {
            initSteps(children);
          }
        } else
          onDoneCallback(addPersonalAssetOptionList, null);
      },
      onError: (message) => setLoadingState(false),
    );
  }

  dispose() {
    _chooseStepModelController.close();
    _loadingController.close();
    _addPersonalAssetChooseStepBloc.dispose();
  }
}
