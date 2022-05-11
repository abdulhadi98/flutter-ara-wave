import 'package:flutter/material.dart';
import 'package:wave_flutter/di/select_personal_asset_dialog_content_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/app_fonts.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/services/data_resource.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import '../loading_indicator.dart';
import 'item_selector/add_personal_asset_selector_widget.dart';
import 'selector_personal_asset_grid_item_widget.dart';

class SelectPersonalAssetTypeDialogContent extends BaseStateFullWidget {
  final Function(PersonalAssetTypeModel type) onTypeSelected;
  SelectPersonalAssetTypeDialogContent({required this.onTypeSelected,});

  @override
  createState() => _SelectPersonalAssetTypeDialogContentState();
}

class _SelectPersonalAssetTypeDialogContentState
    extends BaseStateFullWidgetState<SelectPersonalAssetTypeDialogContent>
    with SelectPersonalAssetTypeDialogContentDi {

  @override
  void initState() {
    initScreenDi();
    super.initState();
    addPersonalAssetBloc.fetchPersonalAssetTypes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildTypesResult();
  }

  Widget buildTypesResult() {
    return StreamBuilder<DataResource<List<PersonalAssetTypeModel>>?>(
        stream: addPersonalAssetBloc.personalAssetTypesStream,
        builder: (context, typesSnapshot) {
          switch (typesSnapshot.data?.status) {
            case Status.LOADING:
              return LoadingIndicator();
            case Status.SUCCESS:
              return AddPersonalAssetSelectorWidget<PersonalAssetTypeModel>(
                title: appLocal.trans('select_asset_type'),
                items: typesSnapshot.data!.data!,
                gridItemBuilder: (isSelected, item) =>
                    SelectorPersonalAssetGridItemWidget(title: item.name, isSelected: isSelected,),
                onNextClicked: widget.onTypeSelected,
              );
            default: return Container();
          }
        }
    );
  }

  Widget buildGridItem(bool isSelected, PersonalAssetTypeModel type) {
    return SelectorPersonalAssetGridItemWidget(title: type.name, isSelected: isSelected,);
  }
}
