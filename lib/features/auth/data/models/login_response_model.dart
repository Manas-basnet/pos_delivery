import 'package:pos_delivery_mobile/core/data/base_response.dart';

class LoginResponseModel extends BaseResponseResult {
  final String? token;
  final String? refreshToken;
  
  LoginResponseModel({
    this.token,
    this.refreshToken,
    super.message,
    super.statusCode,
    super.errorCode,
    super.id,
    super.extra,
  });
  
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      errorCode: json['errorCode'] as int?,
      id: json['id'] as String?,
      extra: json['extra'],
    );
  }
}
