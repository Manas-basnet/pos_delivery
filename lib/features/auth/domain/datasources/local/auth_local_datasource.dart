abstract class AuthLocalDatasource {
  Future<void> saveToken(String token);
  Future<String?> getToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();

  Future<void> clearTokens();
  
  Future<void> saveUserData(String userId, String username);
  Future<void> clearAuthData();
}