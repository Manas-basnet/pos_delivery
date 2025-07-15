enum AppFlavor { dev, staging, prod }

class AppConfig {
  static AppFlavor _flavor = AppFlavor.dev;
  
  static AppFlavor get flavor => _flavor;
  
  static void setFlavor(AppFlavor flavor) {
    _flavor = flavor;
  }
  
  static String get baseUrl {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'https://dev-api.yourapp.com/api/v1';
      case AppFlavor.staging:
        return 'https://staging-api.yourapp.com/api/v1';
      case AppFlavor.prod:
        return 'https://api.yourapp.com/api/v1';
    }
  }
  
  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
  static Duration get sendTimeout => const Duration(seconds: 30);
}