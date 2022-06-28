import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/public_asset_details_screen.dart';

import '../../../helper/app_fonts.dart';

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

  //bool firstTime = true;
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
    initItems();
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
              padding: EdgeInsets.all(width * .008),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: x());
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
  List<AddAssetHoldingDropDownMenuModel> items = [];

  initItems() {
    setState(() {
      duplicateItems = menuItems;
      //items = menuItems;
    });
  }

  List<AddAssetHoldingDropDownMenuModel> duplicateItems = [];

  void filterSearchResults(String query) {
    List<AddAssetHoldingDropDownMenuModel> dummySearchList = [];
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<AddAssetHoldingDropDownMenuModel> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      items.clear();

      items.addAll(duplicateItems);
    }
  }

  // bool isItemsEmpty = true;
  // bool? checkEmpty() {
  //   if (items.isEmpty)
  //     setState(() {
  //       isItemsEmpty = true;
  //     });
  //   else
  //     setState(() {
  //       isItemsEmpty = false;
  //     });
  //   return isItemsEmpty;
  // }

  // var listHeight = checkEmpty ? 0 : height / 4.2;
  String? buttonTextVal;
  bool isSearchingNow = false;
  Widget x() {
    return StreamBuilder<AddAssetHoldingDropDownMenuModel?>(
        stream: selectionStream,
        builder: (context, selectionSnapshot) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: !isSearchingNow
                ? MaterialButton(
                    onPressed: () {
                      setState(() {
                        isSearchingNow = true;
                      });
                    },
                    child: Center(
                      child: Text(
                        buttonTextVal == null ? widget.title : buttonTextVal!,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: AppFonts.getMediumFontSize(context),
                            height: 1.0,
                            color: AppColors.white),
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            //firstTime = true;
                            filterSearchResults(value);
                          },
                          controller: editingController,
                          style: TextStyle(color: AppColors.white),
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: AppColors.gray),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide:
                                  BorderSide(width: 1, color: AppColors.gray),
                            ),
                            labelText: "Search",
                            labelStyle: TextStyle(color: AppColors.grayLight),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.grayLight,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.gray),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                        ),
                        Container(
                          height: items.isEmpty ? 0 : height / 4.9,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.only(left: 0.0, right: 0.0),
                                title: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        print(items[index].name +
                                            '  ' +
                                            items[index].id.toString());
                                        PublicAssetDetailsScreen.companyId =
                                            items[index].id.toString();
                                        PublicAssetDetailsScreen.companyName =
                                            items[index].id.toString();

                                        setSelection(items[index]);
                                        widget.onSelected(items[index]);
                                        setState(() {
                                          isSearchingNow = false;
                                          buttonTextVal = items[index].name;
                                        });
                                      },
                                      child: Text(
                                        '${items[index].name}',
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                AppFonts.getMediumFontSize(
                                                    context),
                                            height: 1.0,
                                            color: AppColors.white),
                                      ),
                                    ),
                                  ],
                                ),
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
