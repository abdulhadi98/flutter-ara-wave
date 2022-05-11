import 'package:flutter/material.dart';
import 'package:wave_flutter/di/add_personal_asset_dialog_content_di.dart';
import 'package:wave_flutter/models/personal_asset_type_step.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import '../../add_asset_dialog.dart';
import '../steps/add_personal_asset_step_dialog_content.dart';
import '../select_personal_asset_type_dialog_content.dart';

class AddPersonalAssetDialogContent extends BaseStateFullWidget {
  final VoidCallback onAssetAdded;
  AddPersonalAssetDialogContent({required this.onAssetAdded});

  @override
  BaseStateFullWidgetState<AddPersonalAssetDialogContent> createState() => _AddPersonalAssetDialogContentState();
}

class _AddPersonalAssetDialogContentState
    extends BaseStateFullWidgetState<AddPersonalAssetDialogContent>
    with AddPersonalAssetDialogContentDi {

  @override
  void initState() {
    initScreenDi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AddAssetDialog(
      contentWidget: buildDialogContent(),
      titleKey: 'add_new_asset',
      loadingStream: uiController.loadingStream,
    );
  }

  Widget buildDialogContent() {
    return StreamBuilder<PersonalAssetType?>(
      stream: uiController.selectedTypeStream,
      builder: (context, typeSnapshot) {
        if(typeSnapshot.data==null) return SelectPersonalAssetTypeDialogContent(
          onTypeSelected: uiController.onTypeSelected,);
        else return buildTypeSteps(typeSnapshot.data!);
      },
    );
  }

  Widget buildTypeSteps(PersonalAssetType type) {
    return AddPersonalAssetStepDialogContent(
      steps: type.steps,
      stepsTitle: type.name,
      onNextClicked: (chooseOptionList, imageUrlList) => uiController.onAddingPersonalAssetHoldingClicked(
        context: context ,
        chooseOptionList: chooseOptionList,
        imageUrlList: imageUrlList,
        onAssetAdded: widget.onAssetAdded,
      ),
    );
  }

}
