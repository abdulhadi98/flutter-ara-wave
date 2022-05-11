import 'package:rxdart/rxdart.dart';
import 'package:wave_flutter/models/upload_image_model.dart';
import 'package:wave_flutter/services/api_provider.dart';

import 'local_user_bloc.dart';

class AddPersonalAssetDocumentStepWidgetBloc {
  final ApiProvider _apiProvider;
  final LocalUserBloc _localUserBloc;
  AddPersonalAssetDocumentStepWidgetBloc({required apiProvider, required localUserBloc})
      : _apiProvider = apiProvider, _localUserBloc = localUserBloc;

  static const String LOG_TAG = 'AddPersonalAssetDocumentStepWidgetBloc';

  String? get currentUserApiToken => _localUserBloc.currentUser?.apiToken;

  uploadImageList({
    required List<UploadImageModel> images,
    required Function(List<String> urls) onData,
    required Function(String message) onError,
  }) {
    int c= 0;
    final List<String> uploadedImageUrls = [];
    uploadFirstFile() {
      _uploadImage(
          uploadImageModel: images[c],
          onData: (url) {
            c++;
            uploadedImageUrls.add(url);
            if (c<images.length) {
              uploadFirstFile();
            } else {
              onData(uploadedImageUrls);
            }
          },
          onError: (e) {
            c++;
            onError(e);
          });
    }

    uploadFirstFile();
  }

  _uploadImage({
    required UploadImageModel uploadImageModel,
    required Function(String url) onData,
    required Function(String message) onError,
  }) async {
    try {
      final response = await _apiProvider.uploadImage(uploadImageModel: uploadImageModel,);
      uploadImageModel.url = response["url"];
      onData(uploadImageModel.url!);
    } on FormatException catch (error) {
      print('$LOG_TAG: uploadImage() FormatException: ${error.message}');
      onError(error.message);
    } catch (error) {
      print('$LOG_TAG: uploadImage() Exception: ${error.toString()}');
      onError('something_went_wrong');
    }
  }

}