import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/add_asset_dialog.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/add_private_subscribed_company_dialog_content.dart';
import 'manually/add_private_asset_manually_dialog_content.dart';
import 'add_private_asset_types_dialog_content.dart';

class AddPrivateAssetDialogContent extends BaseStateFullWidget {
  final VoidCallback onAssetAdded;
  AddPrivateAssetDialogContent({required this.onAssetAdded});

  @override
   createState() => _AddPrivateAssetDialogContentState();
}

class _AddPrivateAssetDialogContentState extends BaseStateFullWidgetState<AddPrivateAssetDialogContent> {

  final BehaviorSubject<AddingPrivateAssetType?> _addingPrivateAssetTypeController = BehaviorSubject<AddingPrivateAssetType?>();
  get addingPrivateAssetTypeStream => _addingPrivateAssetTypeController.stream;
  AddingPrivateAssetType? getAddingPrivateAssetType() => _addingPrivateAssetTypeController.value;
  setAddingPrivateAssetType(AddingPrivateAssetType? type) => _addingPrivateAssetTypeController.sink.add(type);

  @override
  void dispose() {
    _addingPrivateAssetTypeController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AddAssetDialog(
      contentWidget: buildDialogContent(),
      titleKey: 'add_private_asset',
    );
  }

  Widget buildDialogContent() {
    return StreamBuilder<AddingPrivateAssetType?>(
      stream: addingPrivateAssetTypeStream,
      builder: (context, typeSnapshot) {
        switch(typeSnapshot.data) {
          case AddingPrivateAssetType.ADD_ASSET_MANUALLY:
            return AddPrivateAssetManuallyDialogContent(
              onAssetAdded: widget.onAssetAdded,
            );

          case AddingPrivateAssetType.ADD_SUBSCRIBED_COMPANY:
            return AddPrivateSubscribedCompanyDialogContent(
              onAssetAdded: widget.onAssetAdded,
            );

          default: return AddPrivateAssetTypesDialogContent(
            onNextClick: (type) => setAddingPrivateAssetType(type),
          );
        }
        },
    );
  }

}



