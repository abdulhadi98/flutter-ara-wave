import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/bloc/add_personal_asset_document_step_widget_bloc.dart';
import 'package:wave_flutter/helper/enums.dart';
import 'package:wave_flutter/helper/utils.dart';
import 'package:wave_flutter/models/upload_image_model.dart';
import 'package:wave_flutter/ui/root/personal_asset_details_screen.dart';

class AddPersonalAssetDocumentStepWidgetController {
  final AddPersonalAssetDocumentStepWidgetBloc
      _addPersonalAssetDocumentStepWidgetBloc;
  AddPersonalAssetDocumentStepWidgetController(
      {required addPersonalAssetDocumentStepWidgetBloc})
      : _addPersonalAssetDocumentStepWidgetBloc =
            addPersonalAssetDocumentStepWidgetBloc;

  final BehaviorSubject<bool> _validationController =
      BehaviorSubject.seeded(true);
  get validationStream => _validationController.stream;

  final BehaviorSubject<bool> _loadingController =
      BehaviorSubject.seeded(false);
  get loadingStream => _loadingController.stream;
  bool getLoadingState() => _loadingController.value;
  setLoadingState(bool state) => _loadingController.sink.add(state);

  onFinishedClicked({
    required BuildContext context,
    required Function(List<String>? imageUrlList) onFinishedClicked,
  }) {
    if (getPickedPhotoAssets()?.isNotEmpty ?? false) {
      setLoadingState(true);
      List<UploadImageModel> images = _createUploadImageList('personal');
      _addPersonalAssetDocumentStepWidgetBloc.uploadImageList(
        images: images,
        onData: (imageUrlList) =>
            _onHoldingAddingSucceed(context, imageUrlList, onFinishedClicked),
        onError: (message) => _onHoldingAddingFailed(context, message),
      );
    } else {
      onFinishedClicked(null);
    }
  }

  _onHoldingAddingSucceed(
      BuildContext ctx, List<String>? imageUrlList, onFinishedClicked) {
    setLoadingState(false);
    PersonalAssetDetailsScreen.photosList = imageUrlList ?? [];
    print(PersonalAssetDetailsScreen.photosList);
    Utils.showToast('Images Added Successfully');

    onFinishedClicked(imageUrlList);
  }

  _onHoldingAddingFailed(context, String message) {
    setLoadingState(false);
    Utils.showTranslatedToast(context, message);
  }

  List<UploadImageModel> _createUploadImageList(assetType) {
    return getPickedPhotoAssets()!
        .map<UploadImageModel>((e) => UploadImageModel(
              imagebase64: Utils.convertFileToBase64(e!.path),
              imageName: e.name, //ToDO
              assetType:
                  Utils.enumToString(HoldingsType.PERSONAL).toLowerCase(),
              apiToken:
                  _addPersonalAssetDocumentStepWidgetBloc.currentUserApiToken ??
                      '',
            ))
        .toList();
  }

  final BehaviorSubject<List<XFile?>?> pickedPhotoAssetsController =
      BehaviorSubject<List<XFile?>?>();
  get pickedPhotoAssetsStream => pickedPhotoAssetsController.stream;
  List<XFile?>? getPickedPhotoAssets() =>
      pickedPhotoAssetsController.valueOrNull;
  setPickedPhotoAssets(List<XFile?>? photoAssets) =>
      pickedPhotoAssetsController.sink.add(photoAssets);

  onAddPhotoClicked(BuildContext context) {
    Utils.getImagesFromGallery(
      onData: (List<XFile>? xFiles) {
        if (xFiles != null && xFiles.isNotEmpty) {
          if (getPickedPhotoAssets() != null)
            setPickedPhotoAssets(getPickedPhotoAssets()?..addAll(xFiles));
          else
            setPickedPhotoAssets(xFiles);
        }
      },
      onError: () {
        Utils.showTranslatedToast(context, 'something_went_wrong');
      },
    );
  }

  dispose() {
    pickedPhotoAssetsController.close();
    _loadingController.close();
    _validationController.close();
  }
}
