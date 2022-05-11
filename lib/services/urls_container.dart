class UrlsContainer {
  static final String baseUrl = "https://wave.aratech.co";
  static final String baseApiUrl = "$baseUrl/api";

  // Authentication's endpoints
  static String emailLogin = "/login";
  static String emailSignUp = "/register";
  static String forgotPassword = "/forgot-password";
  static String resetPassword = "/reset-password";
  static String logout = "/logout";

  //
  static String getUser = "/get-user";
  static String getUserPortfolioFinancials = "/get-protfolia-financials";
  static String postUpdateUser = "/edit-user";
  static String getAssetsTopPerformance = "/get-assets-top-performance";
  static String getPublicAssets = "/get-public-assets";
  static String getPublicAssetHoldings = "/get-public-asset-holdings";
  static String postAddPublicAssetHolding = "/add-public-asset-holding";
  static String getPublicAssetHolding = "get-public-asset-holding";
  static String getPublicAssetGrowth = "/get-public-asset-growth";
  static String getPrivateAssets = "/get-private-assets";
  static String getPrivateAssetsFinancials = "/get-private-assets-financials";
  static String getPrivateAssetHoldings = "/get-private-asset-holdings";
  static String getPublicAssetsFinancials = "/get-public-assets-financials";
  static String postAddPrivateAssetHolding = "/add-private-asset-holding";
  static String postAddPrivateAssetManualHolding = "/add-private-asset-manual-entry";
  static String postAddPersonalAssetHolding = "/add-personal-asset-holding";
  static String getPersonalAssetTypes = "/get-peronal-asset-types";
  static String getPersonalAssetTypeOptionChildren = "/get-personal-assets-type-option-children";
  static String getPersonalAssetHoldings = "/get-peronal-asset-holdings";
  static String getPersonalAssetsFinancials = "/get-personal-assets-financials";
  static String getHistoricalData = "/get-historical-data";
  static String getPrivateAssetGrowth = "/get-private-asset-growth";
  static String getPublicAssetHistoricalData = "/get-public-asset-historical-data";
  static String getPublicAssetMainGraph = "/get-public-asset-main-graph";
  static String postAddImage = "/add-image";
  static String postAddAssetPriceHistory = "/add-assets-price-history";
  static String confirmPrivateAssetAcquisition = "/confirm-private-asset-acquisition";

}