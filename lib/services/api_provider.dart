import 'package:wave_flutter/models/add_personal_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_holding_model.dart';
import 'package:wave_flutter/models/add_private_asset_manually_model.dart';
import 'package:wave_flutter/models/add_public_asset_holding_model.dart';
import 'package:wave_flutter/models/confirm_private_asset_acquisition_model.dart';
import 'package:wave_flutter/models/price_history_model.dart';
import 'package:wave_flutter/models/public_asset_graph_request_body.dart';
import 'package:wave_flutter/models/public_asset_holding_request_body.dart';
import 'package:wave_flutter/models/upload_image_model.dart';

import '../ui/root/add_assets/personal/steps/text/add_personal_asset_text_step_widget_controller.dart';
import '../ui/root/holdings_screen.dart';
import 'api_handler.dart';
import 'urls_container.dart';

class ApiProvider extends ApiHandler {
  static const String LOG_TAG = 'ApiProvider';

  Future<dynamic> getUser({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(url: '${UrlsContainer.getUser}', body: body);
  }

  Future<dynamic> getUserPortfolioFinancials({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getUserPortfolioFinancials}', body: body);
  }

  Future<dynamic> addPrivateAssetsHolding({
    required AddPrivateAssetHoldingModel addPrivateAssetHoldings,
  }) async {
    final body = addPrivateAssetHoldings.toJson();
    return await postCallApi(
        url: '${UrlsContainer.postAddPrivateAssetHolding}', body: body);
  }

  Future<dynamic> addPrivateAssetsManual({
    required AddPrivateAssetManuallyModel addPrivateAssetManuallyModel,
  }) async {
    final body = addPrivateAssetManuallyModel.toJson();
    return await postCallApi(
        url: '${UrlsContainer.postAddPrivateAssetManualHolding}', body: body);
  }

  Future<dynamic> addPublicAssetsHolding({
    required AddPublicAssetHoldingModel addPublicAssetHoldingModel,
  }) async {
    final body = addPublicAssetHoldingModel.toJson();
    return await postCallApi(
        url: '${UrlsContainer.postAddPublicAssetHolding}', body: body);
  }

  Future<dynamic> getPrivateAssetsHolding({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPrivateAssetHoldings}', body: body);
  }

  Future<dynamic> getPrivateAssetsMaualEntries({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPrivateManualEntries}', body: body);
  }

  Future<dynamic> getPrivateAssets() async {
    return await getCallApi(
      url: '${UrlsContainer.getPrivateAssets}',
    );
  }

  Future<dynamic> getPrivateAssetsFinancials({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPrivateAssetsFinancials}', body: body);
  }

  Future<dynamic> addPersonalAssetsHolding({
    required AddPersonalAssetHoldingModel addPersonalAssetHoldings,
  }) async {
    final body = addPersonalAssetHoldings.toJson();
    return await postCallApi(
        url: '${UrlsContainer.postAddPersonalAssetHolding}', body: body);
  }

  Future<dynamic> getPublicAssetHistoricalData(
      {required token, required String range, required int interval}) async {
    final body = {
      "api_token": token,
      "from_date": DateTime(
              DateTime.now().year - 2, DateTime.now().month, DateTime.now().day)
          .toString()
          .substring(0, 10),
      "to_date": DateTime.now().toString().substring(0, 10),
      "symbol": 'GOOGL',
      "range": range,
      "interval": interval,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetHistoricalData}', body: body);
  }

  Future<dynamic> getPublicAssetMainGraph(
      {required PublicAssetGraphRequestBody
          publicAssetGraphRequestBody}) async {
    final body = publicAssetGraphRequestBody.toJson();
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetMainGraph}', body: body);
  }

  Future<dynamic> getPublicAssetMainGraphDetails(
      {required PublicAssetGraphRequestBody
          publicAssetGraphRequestBody}) async {
    final body = publicAssetGraphRequestBody.toJson();
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetMainGraphDetails}', body: body);
  }

  Future<dynamic> gePublicAssetsHolding({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetHoldings}', body: body);
  }

  Future<dynamic> getPublicAssetHolding(
      {required PublicAssetHoldingRequestBody requestBody}) async {
    final body = requestBody.toJson();
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetsFinancials}', body: body);
  }

  Future<dynamic> getPublicAssetsFinancials({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPublicAssetsFinancials}', body: body);
  }

  Future<dynamic> getPublicAssets() async {
    return await getCallApi(
      url: '${UrlsContainer.getPublicAssets}',
    );
  }

  Future<dynamic> getPersonalAssetsHolding({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPersonalAssetHoldings}', body: body);
  }

  Future<dynamic> getPersonalAssetTypes() async {
    return await getCallApi(
      url: '${UrlsContainer.getPersonalAssetTypes}',
    );
  }

  Future<dynamic> getPersonalAssetTypeOptionChildren({
    required int typeId,
    required int? optionValueId,
  }) async {
    final body = {
      "type_id": typeId,
      "option_value_id": optionValueId,
    };
    HoldingsScreen.typeId = typeId;
    HoldingsScreen.optionValueId = optionValueId.toString();

    return await postCallApi(
      url: '${UrlsContainer.getPersonalAssetTypeOptionChildren}',
      body: body,
    );
  }

  Future<dynamic> getPersonalAssetsFinancials({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getPersonalAssetsFinancials}', body: body);
  }

  Future<dynamic> getAssetsTopPerformance({
    required token,
  }) async {
    final body = {
      "api_token": token,
    };
    return await postCallApi(
        url: '${UrlsContainer.getAssetsTopPerformance}', body: body);
  }

  Future<dynamic> uploadImage({
    required UploadImageModel uploadImageModel,
  }) async {
    final body = uploadImageModel.toJson();
    return await postCallApi(url: '${UrlsContainer.postAddImage}', body: body);
  }

  Future<dynamic> getTopNews() async {
    return await getCustomCallApi(
      url: 'https://rss.app/feeds/trrL6L5yRVzomDm2.xml',
    );
  }

  Future<dynamic> getWorldNews() async {
    return await getCustomCallApi(
      url: 'https://rss.app/feeds/HU7be1PomjovZjnw.xml',
    );
  }

  Future<dynamic> getMyAssetsNews() async {
    return await getCustomCallApi(
      url: 'https://rss.app/feeds/tHl0ppMop8sAho4v.xml',
    );
  }

  Future<dynamic> addAssetPriceHistoryHolding({
    required PriceHistoryModel priceHistoryModel,
  }) async {
    final body = priceHistoryModel.toJson();
    return await postCallApi(
        url: '${UrlsContainer.postAddAssetPriceHistory}', body: body);
  }

  Future<dynamic> confirmPrivateAssetAcquisition({
    required ConfirmPrivateAssetAcquisitionModel
        confirmPrivateAssetAcquisitionModel,
  }) async {
    final body = confirmPrivateAssetAcquisitionModel.toJson();
    return await postCallApi(
        url: '${UrlsContainer.confirmPrivateAssetAcquisition}', body: body);
  }
}
