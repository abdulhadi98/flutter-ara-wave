
class BaseResponse {
  BaseResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  int code;
  String message;
  dynamic data;

factory BaseResponse.fromJson(Map<String, dynamic> json, {dataParser}){
  return BaseResponse(
    code: json["code"],
    message: json["message"],
    data: dataParser!=null ? dataParser() : null,
  );
}

Map<String, dynamic> toJson() => {
  "code": code,
  "message": message,
  "data": data.toJson(),
};
}