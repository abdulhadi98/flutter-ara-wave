import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_personal_asset_step_dialog_content_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/choose/add_personal_asset_choose_step_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/image/add_personal_asset_document_step_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/text/add_personal_asset_text_step_widget.dart';


class AddPersonalAssetStepDialogContent extends BaseStateFullWidget {
  final String stepsTitle;
  final List<PersonalAssetTypeStep> steps;
  final Function(List<AddPersonalAssetOptionModel> chooseOptionList, List<String>? imageUrlList) onNextClicked;
  AddPersonalAssetStepDialogContent({
    required this.stepsTitle,
    required this.steps,
    required this.onNextClicked,
  });

  @override
  createState() => _AddPersonalAssetStepDialogContentState();
}

class _AddPersonalAssetStepDialogContentState
    extends BaseStateFullWidgetState<AddPersonalAssetStepDialogContent>
    with AddPersonalAssetStepDialogContentDi {

  @override
  void initState() {
    initScreenDi(widget.steps, widget.onNextClicked);
    super.initState();
  }

  @override
  void dispose() {
    uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PersonalAssetTypeStep?>(
      stream: uiController.selectedStepStream,
      builder: (context, stepSnapshot) {
        if(stepSnapshot.data==null) return SizedBox();

        return buildStepWidget(stepSnapshot.data!);
      },
    );
  }

  Widget buildStepWidget(PersonalAssetTypeStep step) {
    switch(step.options.first.typeEnum) {
      case AddPersonalAssetHoldingTypeOptionType.choose:
        return buildChooseStepWidget(step);

      case AddPersonalAssetHoldingTypeOptionType.text:
      case AddPersonalAssetHoldingTypeOptionType.date:
        return buildTextStepWidget(step.options);

        case AddPersonalAssetHoldingTypeOptionType.document:
        return buildDocumentStepWidget(step.options);

      default: return SizedBox();
    }
  }

  Widget buildChooseStepWidget(PersonalAssetTypeStep step) {
    PersonalAssetTypeOptionModel option;
    if(step.options.length > 1 ) {
      option = PersonalAssetTypeOptionModel(
          id: -1,
          name: widget.stepsTitle,
          personalAssetTypeId: -1,
          type: Utils.enumToString(AddPersonalAssetHoldingTypeOptionType.choose),
          order: 0,
          step: 1,
        personalAssetTypeOptionValues: step.options.map((e) => PersonalAssetTypeOptionValues(
            id: e.id,
            name: e.name,
            value: '',
            typeOptionId: -1,
        )).toList(),
      );
    } else {
      option = step.options.first;
    }
    return AddPersonalAssetChooseStepWidget(
      option: option,
      onNextClicked: uiController.onChooseStepNextClicked,
    );
  }

  Widget buildTextStepWidget(List<PersonalAssetTypeOptionModel> options) {
    return AddPersonalAssetTextStepWidget(
      key: UniqueKey(),
      options: options,
      onNextClicked: uiController.onTextStepNextClicked,
    );
  }

  Widget buildDocumentStepWidget(List<PersonalAssetTypeOptionModel> options) {
    return AddPersonalAssetDocumentStepWidget(
      onFinishedClicked: uiController.onDocumentStepFinishedClicked,
    );
  }

}
