import 'dart:convert';

abstract class JwtService {
  bool isTokenValid(String token);
  bool isTokenExpired(String token);
  Map<String, dynamic>? decodeToken(String token);
  DateTime? getTokenExpiryDate(String token);
  DateTime? getTokenIssuedDate(String token);
  String? getTokenSubject(String token);
  String? getTokenIssuer(String token);
  List<String>? getTokenAudience(String token);
}

class JwtServiceImpl implements JwtService {
  @override
  bool isTokenValid(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return false;
      
      if (isTokenExpired(token)) return false;
      
      final now = DateTime.now();
      final issuedAt = getTokenIssuedDate(token);
      if (issuedAt != null && now.isBefore(issuedAt)) {
        return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  bool isTokenExpired(String token) {
    try {
      final expiryDate = getTokenExpiryDate(token);
      if (expiryDate == null) return true;
      
      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  @override
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalizedPayload = _normalizeBase64(payload);
      
      final decoded = utf8.decode(base64Url.decode(normalizedPayload));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  DateTime? getTokenExpiryDate(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return null;

      final exp = payload['exp'];
      if (exp == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(
        (exp as int) * 1000,
        isUtc: true,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  DateTime? getTokenIssuedDate(String token) {
    try {
      final payload = decodeToken(token);
      if (payload == null) return null;

      final iat = payload['iat'];
      if (iat == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(
        (iat as int) * 1000,
        isUtc: true,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  String? getTokenSubject(String token) {
    try {
      final payload = decodeToken(token);
      return payload?['sub'] as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  String? getTokenIssuer(String token) {
    try {
      final payload = decodeToken(token);
      return payload?['iss'] as String?;
    } catch (e) {
      return null;
    }
  }

  @override
  List<String>? getTokenAudience(String token) {
    try {
      final payload = decodeToken(token);
      final aud = payload?['aud'];
      
      if (aud is String) {
        return [aud];
      } else if (aud is List) {
        return aud.cast<String>();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }

  String _normalizeBase64(String str) {
    switch (str.length % 4) {
      case 0:
        break;
      case 2:
        str += '==';
        break;
      case 3:
        str += '=';
        break;
      default:
        throw Exception('Invalid base64 string');
    }
    return str;
  }
}