import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_personal_asset_text_step_widget_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/ui/common_widgets/add_asset_text_field.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import '../../../add_asset_action_button.dart';
import 'date_picker_placeholder_widget.dart';

class AddPersonalAssetTextStepWidget extends BaseStateFullWidget {
  final List<PersonalAssetTypeOptionModel> options;
  final Function(List<AddPersonalAssetOptionModel> textOptionList) onNextClicked;
  AddPersonalAssetTextStepWidget({
    required this.options,
    required this.onNextClicked,
    Key? key,
  }): super(key: key);

  @override
  BaseStateFullWidgetState<AddPersonalAssetTextStepWidget> createState() => _AddPersonalAssetTextStepWidgetState();
}

class _AddPersonalAssetTextStepWidgetState
    extends BaseStateFullWidgetState<AddPersonalAssetTextStepWidget>
    with AddPersonalAssetTextStepWidgetDi {

  @override
  void initState() {
    initScreenDi(widget.options);
    super.initState();
  }

  @override
  void dispose() {
    uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height * .03),
        buildGridView(),
        SizedBox(height: height * .06),
        buildNextButton(),
        SizedBox(height: height * .03),
      ],
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .030,
        mainAxisSpacing: height * .03,
        childAspectRatio: 1.65 / 1,
      ),
      itemBuilder: (context, index) {
        return buildGridItem(widget.options[index]);
      },
    );
  }

  Widget buildGridItem(PersonalAssetTypeOptionModel option) {
    switch(option.typeEnum) {
      case AddPersonalAssetHoldingTypeOptionType.text:
        return buildTextFieldGridItem(option);

      case AddPersonalAssetHoldingTypeOptionType.date:
        return buildDateGridItemWidget(option);

      default: return SizedBox();
    }
  }

  Widget buildDateGridItemWidget(PersonalAssetTypeOptionModel option) {
    return DatePickerPlaceholderWidget(
      // key: UniqueKey(),
      hint: option.name,
      onDatedPicked: (date) => uiController.onInputChanged(
          date,
          AddPersonalAssetHoldingTypeOptionType.date,
          option.id,
      ),
    );
  }

  Widget buildTextFieldGridItem(PersonalAssetTypeOptionModel option) {
    return AddAssetTextField(
      // key: UniqueKey(),
      hintKey: option.name,
      onChanged: (value) => uiController.onInputChanged(
          value,
          AddPersonalAssetHoldingTypeOptionType.text,
          option.id,
      ),
    );
  }

  Widget buildNextButton() {
    return AddAssetActionButton(
      validationStream: uiController.validationStream,
      onClicked: () => widget.onNextClicked(uiController.addPersonalAssetOptionList),
      titleKey: 'next',
      iconUrl: 'assets/icons/ic_arrow_next.svg',
      // isDone: type!=null,
    );
  }
}
