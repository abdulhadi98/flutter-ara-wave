import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave_flutter/di/add_personal_asset_document_step_widget_di.dart';
import 'package:wave_flutter/helper/app_colors.dart';
import 'package:wave_flutter/local/app_local.dart';
import 'package:wave_flutter/ui/common_widgets/base_statefull_widget.dart';
import 'package:wave_flutter/ui/root/add_assets/add_asset_action_button.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/add_asset_dialog_content_title_widget.dart';

class AddPersonalAssetDocumentStepWidget extends BaseStateFullWidget {
  final Function(List<String>? imageUrlList) onFinishedClicked;
  AddPersonalAssetDocumentStepWidget({required this.onFinishedClicked});

  @override
  BaseStateFullWidgetState<AddPersonalAssetDocumentStepWidget> createState() => _AddPersonalAssetDocumentStepWidgetState();
}

class _AddPersonalAssetDocumentStepWidgetState
    extends BaseStateFullWidgetState<AddPersonalAssetDocumentStepWidget>
    with AddPersonalAssetDocumentStepWidgetDi {

  @override
  void initState() {
    initScreenDi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: height * .03),
          AddAssetDialogContentTitleWidget(AppLocalizations.of(context).trans('add_photos')),
          SizedBox(height: height * .03),
          buildPersonalPhotosGrid(),
          SizedBox(height: height * .03),
          buildFinishedButton(),
          SizedBox(height: height * .03),
        ],
      ),
    );
  }


  Widget buildPersonalPhotosGrid() {
    photoComponentItem({XFile? xFile}) {
      return Stack(
        children: [
          GestureDetector(
            onTap: () => uiController.onAddPhotoClicked(context),
            child: Container(
              margin: EdgeInsets.only(left: width* .02, top: height* .01,),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: SvgPicture.asset(
                'assets/icons/ic_circular_add.svg',
                width: width * .1,
                height: width * .1,
              ),
            ),
          ),
          if (xFile != null) Positioned(
            top: height* .01,
            left: width* .02,
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              child: Image.file(
                File(xFile.path),
                fit: BoxFit.cover,
                // width: double.infinity,
                // height: double.infinity,
              ),
            ),
          ),
          if(xFile!=null) GestureDetector(
            onTap: () {
              uiController.setPickedPhotoAssets(uiController.getPickedPhotoAssets()?..remove(xFile));
            },
            child: Icon(
              Icons.cancel,
              color: Colors.red.shade400,
              size: width* .075,
            ),
          ),
        ],
      );
    }

    return StreamBuilder<List<XFile?>?>(
      stream: uiController.pickedPhotoAssetsStream,
      builder: (context, photosSnapshot) {
        int gridItemsLength=6;
        if(photosSnapshot.hasData&&photosSnapshot.data!=null){
          if(photosSnapshot.data!.length >= 6) gridItemsLength=photosSnapshot.data!.length+1;
        }
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            // maxCrossAxisExtent: 200,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: width * .030,
            mainAxisSpacing: width * .030,
            crossAxisCount: 2,
          ),
          itemCount: gridItemsLength,
          itemBuilder: (context, index) {
            XFile? photoAsset;
            if(index < (photosSnapshot.data?.length??-1)) photoAsset = photosSnapshot.data![index];
            return photoComponentItem(xFile: photoAsset);
          },
        );
      },
    );
  }

  Widget buildFinishedButton() {
    return AddAssetActionButton(
      loadingStream: uiController.loadingStream,
      validationStream: uiController.validationStream,
      onClicked: () => uiController.onFinishedClicked(
        context: context,
        onFinishedClicked: widget.onFinishedClicked,
      ),
      titleKey: 'finished',
      // isDone: type!=null,
    );
  }

}
