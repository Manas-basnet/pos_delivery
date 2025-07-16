enum AppFlavor { dev, staging, prod }

class AppConfig {
  static AppFlavor _flavor = AppFlavor.dev;
  
  static AppFlavor get flavor => _flavor;
  
  static void setFlavor(AppFlavor flavor) {
    _flavor = flavor;
  }
  
  static String get authBaseUrl {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'https://ums-dev.edap.com.au/api/1';
      case AppFlavor.staging:
        return 'https://ums-dev.edap.com.au/api/1';
      case AppFlavor.prod:
        return 'https://ums.edap.com.au/api/1';
    }
  }
  
  static String get posBaseUrl {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'https://pos-dev.edap.com.au/api/1';
      case AppFlavor.staging:
        return 'https://pos-dev.edap.com.au/api/1';
      case AppFlavor.prod:
        return 'https://theturfman.edap.com.au/api/1';
    }
  }
  
  static String get baseUrl => posBaseUrl;
  
  static Duration get connectTimeout => const Duration(seconds: 5);
  static Duration get receiveTimeout => const Duration(seconds: 5);
  static Duration get sendTimeout => const Duration(seconds: 5);
}