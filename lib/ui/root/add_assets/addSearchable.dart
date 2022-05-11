import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/add_asset_holding_drop_down_menu_model.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';

class SearchableWidget<T> extends BaseStateFullWidget {
  final String title;
  final Function(AddAssetHoldingDropDownMenuModel selectedItem) onSelected;
  final List<T> menuItems;
  SearchableWidget({
    required this.title,
    required this.onSelected,
    required this.menuItems,
  });

  @override
  _SearchableWidgetState createState() => _SearchableWidgetState<T>();
}

class _SearchableWidgetState<T>
    extends BaseStateFullWidgetState<SearchableWidget> {
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
}
//   Widget x() {
//     return SearchWidget<City>(
//       dataList: citiesList,

//       hideSearchBoxWhenItemSelected: false,
//       listContainerHeight: MediaQuery.of(context).size.height / 4,
//       queryBuilder: (query, list) {
//         return list
//             .where(
//                 (item) => item.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       },
//       popupListItemBuilder: (item) {
//         return Container(
//           padding: const EdgeInsets.all(12),
//           child: Text(
//             item.name,
//             style: const TextStyle(fontSize: 16),
//           ),
//         );
//       },
//       selectedItemBuilder: (selectedItem, deleteSelectedItem) {
//         return Container(
//           padding: const EdgeInsets.symmetric(
//             vertical: 2,
//             horizontal: 4,
//           ),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(
//                     left: 16,
//                     right: 16,
//                     top: 8,
//                     bottom: 8,
//                   ),
//                   child: Text(
//                     selectedItem.name,
//                     style: TextStyle(fontSize: 14),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.delete_outline, size: 22),
//                 color: Colors.grey[700],
//                 onPressed: deleteSelectedItem,
//               ),
//             ],
//           ),
//         );
//       },
//       // widget customization
//       noItemsFoundWidget: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Icon(
//             Icons.folder_open,
//             size: 24,
//             color: Colors.grey[900]?.withOpacity(0.7),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             "No Items Found",
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[900]?.withOpacity(0.7),
//             ),
//           ),
//         ],
//       ),
//       textFieldBuilder: (_city, focusNode) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: TextField(
//             onChanged: (val) {
//               setState(() {
//               });
//             },
//             controller: _city,
//             focusNode: focusNode,
//             style: TextStyle(fontSize: 16, color: Colors.grey[600]),
//             decoration: InputDecoration(
//               enabledBorder: const OutlineInputBorder(
//                 borderSide: BorderSide(
//                   color: Color(0x4437474F),
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Theme.of(context).primaryColor),
//               ),
//               suffixIcon: Icon(Icons.search),
//               border: InputBorder.none,
//               hintText: "ابحث عن مدينة ....",
//               contentPadding: const EdgeInsets.only(
//                 left: 16,
//                 right: 20,
//                 top: 14,
//                 bottom: 14,
//               ),
//             ),
//           ),
//         );
//       },
//       onItemSelected: (item) {
//         setState(() {
//           print(item.name);
//           setState(() {
        
//           });
//         });
//       },
//     );
//   }
// }
