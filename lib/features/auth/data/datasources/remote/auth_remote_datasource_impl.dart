import 'package:pos_delivery_mobile/core/network/dio_client.dart';
import 'package:pos_delivery_mobile/core/services/jwt_service.dart';
import 'package:pos_delivery_mobile/core/services/device_info_service.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/login_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/data/models/logout_response_model.dart';
import 'package:pos_delivery_mobile/features/auth/domain/datasources/remote/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;
  final JwtService jwtService;
  final DeviceInfoService deviceInfoService;
  
  AuthRemoteDatasourceImpl({
    required this.dioClient,
    required this.jwtService,
    required this.deviceInfoService,
  });
  
  @override
  Future<LoginResponseModel> login(String username, String password) async {
    final ipAddress = await deviceInfoService.getDeviceIpAddress();
    
    final response = await dioClient.dio.post(
      '/Authentication/GetToken',
      data: {
        "UserName": username,
        "Password": password,
        "ClientId": '3B7772BB-978C-4222-8CA0-3D3D0CC517DB',
        "IpAddress": ipAddress ?? '0.0.0.0',
      },
    );
    
    return LoginResponseModel.fromJson(response.data);
  }
  
  @override
  Future<LogoutResponseModel> logout() async {
    throw UnimplementedError('Logout not implemented yet');
  }
  
  @override
  Future<String> refreshToken(String currentToken) async {
    final response = await dioClient.dio.post(
      '/connect/token',
      data: {
        'refresh_token': currentToken,
        "ClientId": '3B7772BB-978C-4222-8CA0-3D3D0CC517DB',
        'grant_type': 'refresh_token',
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
    return jwtService.isTokenValid(token);
  }
}