import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'dart:math';


class AddPersonalAssetDialogContentController {
  final AddPersonalAssetDialogBloc _addPersonalAssetDialogBloc;
  AddPersonalAssetDialogContentController({required addPersonalAssetDialogBloc,})
      : _addPersonalAssetDialogBloc = addPersonalAssetDialogBloc;

  static const String LOG_TAG = 'AddPersonalAssetDialogContentController';

  final _selectedTypeController = BehaviorSubject<PersonalAssetType?>();
  get selectedTypeStream => _selectedTypeController.stream;
  PersonalAssetType? getSelectedType() => _selectedTypeController.value;
  setSelectedType(PersonalAssetType? type) => _selectedTypeController.sink.add(type);


  void onTypeSelected(PersonalAssetTypeModel type) {
    int maxStepCount = type.personalAssetTypeOptions
        .map((element) => element.step)
        .cast<int>()
        .reduce(max);
    List<PersonalAssetTypeStep> steps = [];
    for(int i=1; i <= maxStepCount; i++){
      List<PersonalAssetTypeOptionModel> options = type.personalAssetTypeOptions.where((element) => element.step==i).toList();
      options.sort((a, b) => a.order.compareTo(b.order));

      PersonalAssetTypeStep step = PersonalAssetTypeStep(
          options: options,
      );
      steps.add(step);
    }

    setSelectedType(PersonalAssetType(id: type.id, name: type.name, steps: steps));
  }


  final BehaviorSubject<bool> _loadingController = BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  onAddingPersonalAssetHoldingClicked({
    required BuildContext context,
    required List<AddPersonalAssetOptionModel> chooseOptionList,
    required List<String>? imageUrlList,
    required VoidCallback onAssetAdded,
  }) async {
    setLoadingState(true);
    _addPersonalAssetDialogBloc.addPersonalAssetHolding(
      addPersonalAssetHoldingModel: _createAddPersonalAssetHoldingModel(chooseOptionList, imageUrlList,),
      onData: () => _onPersonalHoldingAddingSucceed(context, onAssetAdded),
      onError: (message) => _onHoldingAddingFailed(context, message),
    );
  }

  AddPersonalAssetHoldingModel _createAddPersonalAssetHoldingModel(
      List<AddPersonalAssetOptionModel> chooseOptionList,
      List<String>? imageUrlList,
      ) {
    return AddPersonalAssetHoldingModel(
      apiToken: _addPersonalAssetDialogBloc.currentUserApiToken??'',
      assetTypeId: getSelectedType()?.id??-1,
      options: chooseOptionList,
      photos: imageUrlList,
    );
  }

  _onPersonalHoldingAddingSucceed(BuildContext context, VoidCallback onAssetAdded) {
    setLoadingState(false);
    Navigator.of(context).pop();
    onAssetAdded();
  }

  _onHoldingAddingFailed(BuildContext context, String message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  getCurrentStep() {

  }

  dispose() {
    _selectedTypeController.close();
    _loadingController.close();
  }
}