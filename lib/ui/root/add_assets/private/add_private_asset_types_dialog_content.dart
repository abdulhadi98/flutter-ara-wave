import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/add_asset_action_button.dart';

class AddPrivateAssetTypesDialogContent extends BaseStateFullWidget {
  final Function(AddingPrivateAssetType type) onNextClick;
  AddPrivateAssetTypesDialogContent({required this.onNextClick,});

  @override
  createState() => _AddPrivateAssetTypesDialogContentState();
}

class _AddPrivateAssetTypesDialogContentState extends BaseStateFullWidgetState<AddPrivateAssetTypesDialogContent> {

  final BehaviorSubject<AddingPrivateAssetType?> _addingPrivateAssetTypeController = BehaviorSubject<AddingPrivateAssetType?>();
  ValueStream<AddingPrivateAssetType?> get addingPrivateAssetTypeStream => _addingPrivateAssetTypeController.stream;
  AddingPrivateAssetType? getAddingPrivateAssetType() => _addingPrivateAssetTypeController.value;
  setAddingPrivateAssetType(AddingPrivateAssetType? type) => _addingPrivateAssetTypeController.sink.add(type);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _addingPrivateAssetTypeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildScreenContent();
  }

  Widget buildScreenContent() {
    return StreamBuilder<AddingPrivateAssetType?>(
        stream: addingPrivateAssetTypeStream,
        builder: (context, selectedTypeSnapshot) {
          return Column(
            children: [
              SizedBox(height: height * .06),
              buildSelectedItem(
                isSelected: selectedTypeSnapshot.data == AddingPrivateAssetType.ADD_ASSET_MANUALLY,
                type: AddingPrivateAssetType.ADD_ASSET_MANUALLY,
                titleKey: 'add_assets_manually',
              ),
              SizedBox(height: height * .03),
              buildSelectedItem(
                isSelected: selectedTypeSnapshot.data == AddingPrivateAssetType.ADD_SUBSCRIBED_COMPANY,
                type: AddingPrivateAssetType.ADD_SUBSCRIBED_COMPANY,
                titleKey: 'add_subscribed_company',
              ),
              SizedBox(height: height * .06),
              buildNextButton(type: selectedTypeSnapshot.data),
              SizedBox(height: height * .03),
            ],
          );
        }
    );
  }

  Widget buildSelectedItem({
    required bool isSelected,
    required AddingPrivateAssetType type,
    required String titleKey,
  }) {
    return GestureDetector(
      onTap: () => setAddingPrivateAssetType(type),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: height * .020),
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          border: Border.all(color: isSelected ? Colors.white : AppColors.mainColor, width: .5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          appLocal.trans(titleKey),
          style: TextStyle(
            color: AppColors.white,
            fontSize: AppFonts.getNormalFontSize(context),
            height: 1.0,
          ),
        ),
      ),
    );
  }

  Widget buildNextButton({required AddingPrivateAssetType? type}) {
    return AddAssetActionButton(
      validationStream: addingPrivateAssetTypeStream.map((event) => event!=null).shareValue(),
      onClicked: () => widget.onNextClick(type!),
      titleKey: 'next',
      iconUrl: 'assets/icons/ic_arrow_next.svg',
      // isDone: type!=null,
    );
  }

}
