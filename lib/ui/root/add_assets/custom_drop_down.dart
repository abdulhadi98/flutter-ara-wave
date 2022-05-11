import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

class CustomDropDownWidget<T> extends BaseStateFullWidget {
  final String title;
  final Function(AddAssetHoldingDropDownMenuModel selectedItem) onSelected;
  final List<T> menuItems;
  CustomDropDownWidget({
    required this.title,
    required this.onSelected,
    required this.menuItems,
  });

  @override
  _CustomDropDownWidgetState createState() => _CustomDropDownWidgetState<T>();
}

class _CustomDropDownWidgetState<T>
    extends BaseStateFullWidgetState<CustomDropDownWidget> {
  late List<AddAssetHoldingDropDownMenuModel> menuItems;

  final BehaviorSubject<AddAssetHoldingDropDownMenuModel?> selectionController =
      BehaviorSubject<AddAssetHoldingDropDownMenuModel?>();
  get selectionStream => selectionController.stream;
  AddAssetHoldingDropDownMenuModel? getSelection() =>
      selectionController.valueOrNull;
  setSelection(AddAssetHoldingDropDownMenuModel? company) =>
      selectionController.sink.add(company);

  @override
  void initState() {
    menuItems = widget.menuItems
        .map((e) => AddAssetHoldingDropDownMenuModel(
              id: e.id ?? '',
              name: e.name ?? '',
            ))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    selectionController.close();
    super.dispose();
  }

  bool isSearching = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AddAssetHoldingDropDownMenuModel?>(
        stream: selectionStream,
        builder: (context, selectionSnapshot) {
          return Container(
            padding: EdgeInsets.only(left: width * .02, right: width * .02),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<AddAssetHoldingDropDownMenuModel>(
              value: Utils.findItemById(
                  menuItems,
                  selectionSnapshot.data
                      ?.id) /*??AddAssetHoldingDropDownMenuModel(id: -1, name: '')*/,
              hint: Center(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      height: 1.0, color: AppColors.white.withOpacity(.3)),
                ),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              iconSize: width * .055,
              elevation: 0,
              underline: SizedBox(),
              style: const TextStyle(color: Colors.white),
              onChanged: (AddAssetHoldingDropDownMenuModel? newValue) {
                if (newValue != null) {
                  setSelection(newValue);
                  widget.onSelected(newValue);
                }
              },
              dropdownColor: AppColors.mainColor,
              items: buildDropDownItems(),
            ),
          );
        });
  }

  List<DropdownMenuItem<AddAssetHoldingDropDownMenuModel>>
      buildDropDownItems() {
    return menuItems.map<DropdownMenuItem<AddAssetHoldingDropDownMenuModel>>(
        (AddAssetHoldingDropDownMenuModel value) {
      return buildDropDownItem(value);
    }).toList();
  }

  DropdownMenuItem<AddAssetHoldingDropDownMenuModel> buildDropDownItem(
    value,
  ) {
    return DropdownMenuItem<AddAssetHoldingDropDownMenuModel>(
      value: value,
      child: Center(
        child: Text(
          value.name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            height: 1.0,
          ),
        ),
      ),
    );
  }

  TextEditingController editingController = TextEditingController();
  var items = [];

  final duplicateItems = List<String>.generate(5, (i) => "Item $i");
  void filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  Widget x() {
    return StreamBuilder<AddAssetHoldingDropDownMenuModel?>(
        stream: selectionStream,
        builder: (context, selectionSnapshot) {
          return Container(
            padding: EdgeInsets.only(left: width * .02, right: width * .02),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value);
                      },
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${items[index]}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
