import 'package:udharoo/core/network/dio_client.dart';
import 'package:udharoo/core/services/device_info_service.dart';
import 'package:udharoo/features/auth/data/models/login_response_model.dart';
import 'package:udharoo/features/auth/data/models/logout_response_model.dart';
import 'package:udharoo/features/auth/domain/datasources/remote/auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final DioClient dioClient;
  final DeviceInfoService deviceInfoService;
  
  AuthRemoteDatasourceImpl({
    required this.dioClient,
    required this.deviceInfoService,
  });
  
  @override
  Future<LoginResponseModel> login(String username, String password) async {
    throw UnimplementedError('Login not implemented yet');
  }
  
  @override
  Future<LogoutResponseModel> logout() async {
    throw UnimplementedError('Logout not implemented yet ');
  }
  
  @override
  Future<String> refreshToken(String currentToken) async {
    throw UnimplementedError('Refresh token not implemented yet');
  }
  
  @override
  Future<bool> validateToken(String token) async {
    throw UnimplementedError('Token validation not implemented yet');
  }
}