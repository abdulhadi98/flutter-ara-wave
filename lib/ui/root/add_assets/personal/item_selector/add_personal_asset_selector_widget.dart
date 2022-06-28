import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wave_flutter/di/add_personal_asset_selector_widget_di.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/add_asset_action_button.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/item_selector/add_personal_asset_selector_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/add_asset_dialog_content_title_widget.dart';

class AddPersonalAssetSelectorWidget<T> extends BaseStateFullWidget {
  final List<T> items;
  final gridItemBuilder;
  final onNextClicked;
  final String title;
  AddPersonalAssetSelectorWidget({
    required this.items,
    required this.gridItemBuilder,
    required this.onNextClicked,
    required this.title,
  });

  @override
  createState() => _AddPersonalAssetSelectorWidgetState<T>();
}

class _AddPersonalAssetSelectorWidgetState<T>
    extends BaseStateFullWidgetState<AddPersonalAssetSelectorWidget>
    with AddPersonalAssetSelectorWidgetDi<T> {
  @override
  void initState() {
    initScreenDi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return buildItemSelector();
  }

  Widget buildItemSelector() {
    return StreamBuilder<T?>(
        stream: uiController.selectedItemStream,
        builder: (context, selectedSnapshot) {
          return Column(
            children: [
              SizedBox(height: height * .03),
              AddAssetDialogContentTitleWidget(widget.title),
              SizedBox(height: height * .03),
              buildTypesGrid(
                items: widget.items as List<T>,
                selectedItem: selectedSnapshot.data,
              ),
              SizedBox(height: height * .06),
              buildNextButton(item: selectedSnapshot.data),
              SizedBox(height: height * .03),
            ],
          );
        });
  }

  Widget buildTypesGrid({required List<T> items, required T? selectedItem}) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: width * .030,
        mainAxisSpacing: height * .03,
        childAspectRatio: 2 / 1,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => uiController.onGridItemClicked(items[index]),
          child: widget.gridItemBuilder(
            items[index] == selectedItem,
            items[index],
          ),
        );
      },
    );
  }

  Widget buildNextButton({required T? item}) {
    return AddAssetActionButton(
      validationStream: uiController.validationStream,
      onClicked: () => widget.onNextClicked(item!),
      titleKey: 'next',
      iconUrl: 'assets/icons/ic_arrow_next.svg',
      // isDone: type!=null,
    );
  }
}
