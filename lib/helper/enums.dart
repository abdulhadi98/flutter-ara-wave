enum AppMainScreens {
  HOME_SCREEN,
  MY_PORTFOLIO_SCREEN,
  NEWS_SCREEN,
  OPTIONS_SCREEN,
  HOLDINGS_SCREEN,
  PRIVATE_ASSET_DETAILS_SCREEN,
  PERSONAL_ASSET_DETAILS_SCREEN,
  PERSONAL_ASSET_MANUAL_DETAILS_SCREEN,
  PUBLIC_ASSET_DETAILS_SCREEN
  

}
enum ChartFilters { x24H, x7D, x1M, x3M, x6M, x1Y, xALL }
enum HoldingsType { PRIVATE, PUBLIC, PERSONAL }
enum ChartsType { AREA, COLUMN, COLUMN_ROUNDED_CORNER, RANGE_COLUMN, DOUGHNUT }
enum AddingPersonalAssetStages { TYPE, INFO, IMAGES }
enum AddingPrivateAssetType { ADD_ASSET_MANUALLY, ADD_SUBSCRIBED_COMPANY }
enum AddingPrivateAssetStep { COMPANY, COMPANY_INFO, COMPANY_SHARES, PRICE_HISTORY }
enum NewsType { WORLD, MY_ASSETS, }
enum AddPersonalAssetHoldingTypeOptionType { choose, text, date, document }
enum AddPersonalAssetChooseStepType { optionValues, steps }
enum PublicAssetHistoricalDataRanges {
  minute,
  hour,
  day,
  week,
  month,
  quarter,
  year,
}