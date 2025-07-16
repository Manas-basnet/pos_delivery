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
  
  static String get clientId {
    switch (_flavor) {
      case AppFlavor.dev:
        return '3B7772BB-978C-4222-8CA0-3D3D0CC517DB';
      case AppFlavor.staging:
        return '3B7772BB-978C-4222-8CA0-3D3D0CC517DB';
      case AppFlavor.prod:
        return '3F0CBEFA-7E35-4208-8BED-BD895A540080';
    }
  }

  static String get baseUrl => posBaseUrl;

  static Duration get connectTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
  static Duration get sendTimeout => const Duration(seconds: 30);
}
