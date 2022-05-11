import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_personal_asset_choose_step_widget_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/choose_step_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/loading_indicator.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/item_selector/add_personal_asset_selector_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/add_personal_asset_step_dialog_content.dart';
import '../../selector_personal_asset_grid_item_widget.dart';

class AddPersonalAssetChooseStepWidget extends BaseStateFullWidget {
  final PersonalAssetTypeOptionModel option;
  final Function(List<AddPersonalAssetOptionModel> chooseOptionList, List<String>? imageUrlList) onNextClicked;
  AddPersonalAssetChooseStepWidget({
    required this.option,
    required this.onNextClicked,
  });
  @override
  BaseStateFullWidgetState<AddPersonalAssetChooseStepWidget> createState() => _AddPersonalAssetChooseStepWidgetState();
}

class _AddPersonalAssetChooseStepWidgetState
    extends BaseStateFullWidgetState<AddPersonalAssetChooseStepWidget>
    with AddPersonalAssetChooseStepWidgetDi {

  @override
  void initState() {
    initScreenDi();
    super.initState();
  }

  @override
  void dispose() {
    uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: uiController.loadingStream,
      builder: (context, loadingSnapshot) {
        if(loadingSnapshot.data??false) {
          return LoadingIndicator();
        } else {
          return buildContent();
        }
      },
    );
  }

  Widget buildContent() {
    return StreamBuilder<ChooseStepModel?>(
        stream: uiController.stepsStream,
        builder: (context, chooseStepModelSnapshot) {
          switch(chooseStepModelSnapshot.data?.type) {
            case AddPersonalAssetChooseStepType.optionValues:
              return buildOptionValuesStepTypeWidget(
                title: chooseStepModelSnapshot.data!.option!.personalAssetTypeOptionValues!.first.name,
                values: chooseStepModelSnapshot.data!.option!.personalAssetTypeOptionValues!,
              );

            case AddPersonalAssetChooseStepType.steps:
              return AddPersonalAssetStepDialogContent(
                stepsTitle: widget.option.name,
                steps: chooseStepModelSnapshot.data!.steps!,
                onNextClicked: widget.onNextClicked,
              );

            default:return buildOptionValuesStepTypeWidget(
              title: widget.option.name,
              values: widget.option.personalAssetTypeOptionValues!,
            );
          }
        }
    );
  }

  Widget buildOptionValuesStepTypeWidget({
    required String title,
    required List<PersonalAssetTypeOptionValues> values,

  }) {
    return AddPersonalAssetSelectorWidget<PersonalAssetTypeOptionValues>(
      title: title,
      items: values,
      gridItemBuilder: (isSelected, item) => SelectorPersonalAssetGridItemWidget(
        title: item.name,
        isSelected: isSelected,
      ),
      onNextClicked:(item) => uiController.onNextClicked(
        optionValue: item,
        onDoneCallback: widget.onNextClicked,
      ),
    );
  }

}
