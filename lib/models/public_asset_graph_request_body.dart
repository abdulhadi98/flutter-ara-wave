class PublicAssetGraphRequestBody {
  final String apiToken;
  final String fromDate;
  final String toDate;
  final String range;
  final int interval;
  final String? sympol;

  PublicAssetGraphRequestBody({
    required this.apiToken,
    required this.fromDate,
    required this.toDate,
    required this.range,
    required this.interval,
    this.sympol
  });

  Map<String, dynamic> toJson() => {
        "api_token": apiToken,
        "from_date": fromDate,
        "to_date": toDate,
        "range": range,
        "interval": interval,
        "symbol":sympol
      };
}
