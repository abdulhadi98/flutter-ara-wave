import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_personal_asset_text_step_widget_di.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/ui/common_widgets/add_asset_text_field.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/holdings_screen.dart';
import '../../../add_asset_action_button.dart';
import 'date_picker_placeholder_widget.dart';

class AddPersonalAssetTextStepWidget extends BaseStateFullWidget {
  final List<PersonalAssetTypeOptionModel> options;
  final Function(List<AddPersonalAssetOptionModel> textOptionList)
      onNextClicked;
  AddPersonalAssetTextStepWidget({
    required this.options,
    required this.onNextClicked,
    Key? key,
  }) : super(key: key);

  @override
  BaseStateFullWidgetState<AddPersonalAssetTextStepWidget> createState() =>
      _AddPersonalAssetTextStepWidgetState();
}

class _AddPersonalAssetTextStepWidgetState
    extends BaseStateFullWidgetState<AddPersonalAssetTextStepWidget>
    with AddPersonalAssetTextStepWidgetDi {
  @override
  void initState() {
    initScreenDi(widget.options);
    // print('zzz typeId' +
    //     HoldingsScreen.typeId.toString() +
    //     '  optionValueId ' +
    //     HoldingsScreen.optionValueId);
    // uiController.addPurchasedPrice(
    //     HoldingsScreen.typeId, 'choose', HoldingsScreen.optionValueId);
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

  int i = 0;
  Widget buildGridView() {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .030,
        mainAxisSpacing: height * .03,
        childAspectRatio: 1.65 / .7,
      ),
      itemBuilder: (context, index) {
        // if (i == 0 && HoldingsScreen.typeId == 138) {
        //   uiController.addPurchasedPrice(HoldingsScreen.typeId, 'choose',
        //       HoldingsScreen.optionValueId.toString());
        //   i++;

        //   print('digital choose addded');
        // }
        if (widget.options[index].type == 'hidden' /*can use id insted*/) {
          if (HoldingsScreen.typeId == 137) //|| HoldingsScreen.typeId == 138
          {
            print('137 saving added');
            uiController.addPurchasedPrice(HoldingsScreen.typeId, 'choose',
                HoldingsScreen.optionValueId.toString());

            uiController.addPurchasedPrice(
                widget.options[index].id, widget.options[index].type, '');
          } //add this value (id: 63,type:'text',value:'empty', ),
          if (HoldingsScreen.typeId == 138) //|| HoldingsScreen.typeId == 138
          {
            print('138 digital added');

            uiController.addPurchasedPrice(HoldingsScreen.typeId, 'choose',
                HoldingsScreen.optionValueId.toString());
          }
          print('xcxcxcx ' + HoldingsScreen.typeId.toString());
          print('cvcvcvcv ' + HoldingsScreen.optionValueId.toString());

          //add this value (id: 63,type:'text',value:'empty', ),
          //  / uiController.validateAddPersonalAssetInfo(addList)
          print(widget.options[index].id.toString() +
              '  ' +
              widget.options[index].type);
          return Container(); // this for UI
        }
        return buildGridItem(widget.options[index]);
        // return Container();
      },
    );
  }

  Widget buildGridItem(PersonalAssetTypeOptionModel option) {
    switch (option.typeEnum) {
      case AddPersonalAssetHoldingTypeOptionType.text:
        print(option.name + '    ' + option.id.toString());
        return buildTextFieldGridItem(option);

      case AddPersonalAssetHoldingTypeOptionType.date:
        return buildDateGridItemWidget(option);

      default:
        return SizedBox();
    }
  }

  Widget buildTextFieldGridItem(PersonalAssetTypeOptionModel option) {
    return AddAssetTextField(
        // key: UniqueKey(),
        hintKey: option.name,
        onChanged: (value) {
          uiController.onInputChanged(
            value,
            AddPersonalAssetHoldingTypeOptionType.text,
            option.id,
          );
        });
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

  Widget buildNextButton() {
    return AddAssetActionButton(
      validationStream: uiController.validationStream,
      onClicked: () {
        print(HoldingsScreen.typeId);
        widget.onNextClicked(uiController.addPersonalAssetOptionList);
      },

      titleKey: 'next',
      iconUrl: 'assets/icons/ic_arrow_next.svg',
      // isDone: type!=null,
    );
  }
}
