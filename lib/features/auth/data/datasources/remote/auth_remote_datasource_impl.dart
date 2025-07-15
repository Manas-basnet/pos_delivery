import 'package:dio/dio.dart';
import 'package:pos_delivery_mobile/core/network/dio_client.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/login_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/logout_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/domain/datasources/remote/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;
  
  AuthRemoteDatasourceImpl({required this.dioClient});
  
  @override
  Future<LoginResponseModel> login(String username, String password) async {
    final response = await dioClient.dio.post(
      '/auth/login',
      data: {
        'username': username,
        'password': password,
      },
    );
    
    return LoginResponseModel.fromJson(response.data);
  }
  
  @override
  Future<LogoutResponseModel> logout() async {
    final response = await dioClient.dio.post('/auth/logout');
    
    return LogoutResponseModel.fromJson(response.data);
  }
  
  @override
  Future<String> refreshToken(String currentToken) async {
    final response = await dioClient.dio.post(
      '/auth/refresh',
      data: {
        'refreshToken': currentToken,
      },
    );
    
    final newToken = response.data['token'] as String?;
    if (newToken == null || newToken.isEmpty) {
      throw Exception('Invalid token response');
    }
    
    return newToken;
  }
  
  @override
  Future<bool> validateToken(String token) async {
    final tempDio = Dio();
    tempDio.options = dioClient.dio.options.copyWith();
    tempDio.options.headers['Authorization'] = 'Bearer $token';
    
    final response = await tempDio.get('/auth/validate');
    
    return response.data['valid'] == true;
  }
}