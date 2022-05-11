import 'package:flutter/material.dart';

class AddPersonalAssetGridView<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final Function(bool isSelected, T item,) gridItemBuilder;

  const AddPersonalAssetGridView({
    required this.items,
    required this.selectedItem,
    required this.gridItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return buildTypesGrid(context);
  }

  Widget buildTypesGrid(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        return gridItemBuilder(
          items[index]==selectedItem,
          items[index],
        );
      },
    );
  }

}
