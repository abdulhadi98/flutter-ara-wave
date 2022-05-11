import 'package:get_it/get_it.dart';
import 'package:wave_flutter/bloc/AddPrivateAssetManuallyBloc.dart';
import 'package:wave_flutter/bloc/AddPrivateSubscribedCompanyBloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_choose_step_widget_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_dialog_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_document_step_widget_bloc.dart';
import 'package:wave_flutter/bloc/add_personal_asset_step_dialog_content_bloc.dart';
import 'package:wave_flutter/bloc/add_public_asset_holding_bloc.dart';
import 'package:wave_flutter/bloc/local_user_bloc.dart';
import 'package:wave_flutter/bloc/mixin/IAddPrivateAssetManuallyBloc.dart';
import 'package:wave_flutter/bloc/mixin/IAddPrivateSubscribedCompanyBloc.dart';
import 'package:wave_flutter/bloc/general_bloc.dart';
import 'package:wave_flutter/bloc/holdings_screen_bloc.dart';
import 'package:wave_flutter/bloc/home_screen_bloc.dart';
import 'package:wave_flutter/bloc/my_portfolio_screen_bloc.dart';
import 'package:wave_flutter/bloc/news_screen_bloc.dart';
import 'package:wave_flutter/bloc/authentication_bloc.dart';
import 'package:wave_flutter/bloc/price_history_bloc.dart';
import 'package:wave_flutter/bloc/private_asset_details_screen_bloc.dart';
import 'package:wave_flutter/bloc/select_company_step_dialog_bloc.dart';
import 'package:wave_flutter/bloc/select_personal_asset_type_dialog_content_bloc.dart';
import 'package:wave_flutter/di/my_portfolio_screen_di.dart';
import 'package:wave_flutter/models/personal_asset_type.dart';
import 'package:wave_flutter/services/api_provider.dart';
import 'package:wave_flutter/services/auth_provider.dart';
import 'package:wave_flutter/storage/data_store.dart';
import 'package:wave_flutter/ui/animation/animated_logo_animation_manager.dart';
import 'package:wave_flutter/ui/controllers/add_asset_dialog_content_controller.dart';
import 'package:wave_flutter/ui/controllers/holdings_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/home_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/login_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/news_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/personal_asset_details_controllers.dart';
import 'package:wave_flutter/ui/controllers/private_asset_details_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/forget_password_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/reset_password_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/root_screen_controller.dart';
import 'package:wave_flutter/ui/controllers/sign_up_screen_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/dialog_content/add_personal_asset_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/item_selector/add_personal_asset_selector_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/add_personal_asset_step_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/choose/add_personal_asset_choose_step_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/image/add_personal_asset_document_step_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/personal/steps/text/add_personal_asset_text_step_widget_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/price_history/price_history_step_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/manually/add_private_asset_manually_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/add_private_subscribed_company_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/company_info_step_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/company_shares_step_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/private/subscribed_company/select_company_step_dialog_content_controller.dart';
import 'package:wave_flutter/ui/root/add_assets/public/add_public_asset_holding_dialog_content_controller.dart';

class RegistrationDiContainer {

  GetIt _getIt = GetIt.instance;

  registerDependencies() {
    /* Singleton */
    _getIt.registerLazySingleton<DataStore>(() => DataStore());
    _getIt.registerLazySingleton<ApiProvider>(() => ApiProvider());
    _getIt.registerLazySingleton<AuthProvider>(() => AuthProvider());
    _getIt.registerLazySingleton<GeneralBloc>(() => GeneralBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>()));
    _getIt.registerLazySingleton<LocalUserBloc>(() => LocalUserBloc(dataStore: _getIt<DataStore>()));
    /**/

    /* Lazy */
    _getIt.registerLazySingleton<RootScreenController>(() => RootScreenController());

     /**/

    /* Factory */
    _getIt.registerFactory<AnimatedLogoAnimationManager>(() => AnimatedLogoAnimationManager());
    _getIt.registerFactoryParam((param1, param2) => HomeScreenController(homeScreenBloc: param1, authBloc: param2));
    _getIt.registerFactory<HomeScreenBloc>(() => HomeScreenBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>(), generalBLoc: _getIt<GeneralBloc>(),));
    _getIt.registerFactoryParam((holdingsScreenBloc, _) => HoldingsScreenController(holdingsScreenBloc: holdingsScreenBloc,));
    _getIt.registerFactoryParam((holdingsScreenBloc, _) => AddAssetDialogContentController(holdingsScreenBloc: holdingsScreenBloc,));
    _getIt.registerFactory<MyPortfolioScreenBloc>(() => MyPortfolioScreenBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>(), generalBLoc: _getIt<GeneralBloc>(),));
    _getIt.registerFactory<HoldingsScreenBloc>(() => HoldingsScreenBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>(), generalBLoc: _getIt<GeneralBloc>(),));
    _getIt.registerFactory<PrivateAssetDetailsScreenBloc>(() => PrivateAssetDetailsScreenBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>(), generalBLoc: _getIt<GeneralBloc>(),));
    _getIt.registerFactoryParam((param1, _) => PrivateAssetDetailsScreenController(privateAssetDetailsScreenBloc: param1));
    _getIt.registerFactory<PersonalAssetDetailsScreenController>(() => PersonalAssetDetailsScreenController());
    _getIt.registerFactory<NewsScreenBloc>(() => NewsScreenBloc(apiProvider: _getIt<ApiProvider>(), dataStore: _getIt<DataStore>()));
    _getIt.registerFactory<NewsScreenController>(() => NewsScreenController());
    _getIt.registerFactory<AuthenticationBloc>(() => AuthenticationBloc(authProvider: _getIt<AuthProvider>(), dataStore: _getIt<DataStore>()));
    _getIt.registerFactory<LoginScreenController>(() => LoginScreenController());
    _getIt.registerFactory<SignUpScreenController>(() => SignUpScreenController());
    _getIt.registerFactoryParam((param1, _) => ForgetPasswordScreenController(authenticationBloc: param1));
    _getIt.registerFactoryParam((param1, _) => ResetPasswordScreenController(authenticationBloc: param1));
    _getIt.registerFactory<AddPrivateAssetManuallyBloc>(() => AddPrivateAssetManuallyBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactory<AddPrivateSubscribedCompanyBloc>(() => AddPrivateSubscribedCompanyBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPrivateSubscribedCompanyBloc, _) => AddPrivateSubscribedCompanyDialogContentController(
      addPrivateSubscribedCompanyBloc: addPrivateSubscribedCompanyBloc,
    ));
    _getIt.registerFactoryParam((addPrivateAssetManuallyBloc, _) => AddPrivateAssetManuallyDialogContentController(
      addPrivateAssetManuallyBloc: addPrivateAssetManuallyBloc,
    ));
    _getIt.registerFactory<SelectCompanyStepDialogBloc>(() => SelectCompanyStepDialogBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((selectCompanyStepDialogBloc, _) => SelectCompanyStepDialogContentController(
      selectCompanyStepDialogBloc: selectCompanyStepDialogBloc,
    ));
    _getIt.registerFactory<CompanyInfoStepDialogContentController>(() => CompanyInfoStepDialogContentController());
    _getIt.registerFactory<CompanySharesStepDialogContentController>(() => CompanySharesStepDialogContentController());
    _getIt.registerFactory<PriceHistoryBloc>(() => PriceHistoryBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPriceHistoryParams, priceHistoryBloc,) => PriceHistoryStepDialogContentController(
      priceHistoryBloc: priceHistoryBloc,
      addPriceHistoryParams: addPriceHistoryParams,
    ));
    _getIt.registerFactory<AddPublicAssetHoldingBloc>(() => AddPublicAssetHoldingBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPublicAssetHoldingBloc, _) => AddPublicAssetHoldingDialogContentController(
      addPublicAssetHoldingBloc: addPublicAssetHoldingBloc,
    ));
    _getIt.registerFactory<SelectPersonalAssetTypeDialogContentBloc>(() => SelectPersonalAssetTypeDialogContentBloc(
      apiProvider: _getIt<ApiProvider>(),
    ));
    _getIt.registerFactory(() => AddPersonalAssetSelectorWidgetController<PersonalAssetTypeModel>());
    _getIt.registerFactory(() => AddPersonalAssetSelectorWidgetController<PersonalAssetTypeOptionValues>());
    _getIt.registerFactory<AddPersonalAssetDialogBloc>(() => AddPersonalAssetDialogBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPersonalAssetDialogBloc, _) => AddPersonalAssetDialogContentController(
      addPersonalAssetDialogBloc: addPersonalAssetDialogBloc,
    ));
    _getIt.registerFactory(() => AddPersonalAssetStepDialogContentBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPersonalAssetStepDialogContentBloc, params) => AddPersonalAssetStepDialogContentController(
      addPersonalAssetStepDialogContentBloc: addPersonalAssetStepDialogContentBloc,
      params: params,
    ));
    _getIt.registerFactoryParam((options, _) => AddPersonalAssetTextStepWidgetController(
      options: options,
    ));
    _getIt.registerFactory(() => AddPersonalAssetChooseStepWidgetBloc(
      apiProvider: _getIt<ApiProvider>(),
    ));
    _getIt.registerFactoryParam((addPersonalAssetChooseStepWidgetBloc, _) => AddPersonalAssetChooseStepWidgetController(
      addPersonalAssetChooseStepBloc: addPersonalAssetChooseStepWidgetBloc,
    ));
    _getIt.registerFactory(() => AddPersonalAssetDocumentStepWidgetBloc(
      apiProvider: _getIt<ApiProvider>(),
      localUserBloc: _getIt<LocalUserBloc>(),
    ));
    _getIt.registerFactoryParam((addPersonalAssetDocumentStepWidgetBloc, _) => AddPersonalAssetDocumentStepWidgetController(
      addPersonalAssetDocumentStepWidgetBloc: addPersonalAssetDocumentStepWidgetBloc,
    ));
    /**/
  }

}