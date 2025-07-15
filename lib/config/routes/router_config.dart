import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pos_delivery_mobile/config/routes/routes_constants.dart';
import 'package:pos_delivery_mobile/core/di/di.dart' as di;
import 'package:pos_delivery_mobile/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:pos_delivery_mobile/features/auth/presentation/pages/login_screen.dart';
import 'package:pos_delivery_mobile/features/home/presentation/pages/home_screen.dart';
import 'package:pos_delivery_mobile/features/profile/presentation/pages/profile_screen.dart';
import 'package:pos_delivery_mobile/shared/presentation/pages/splash_screen.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();

  AppRouter._internal();

  factory AppRouter() {
    return _instance;
  }

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();
  static final _profileNavigatorKey = GlobalKey<NavigatorState>();
  static final _settingsNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authCubit = context.read<AuthCubit>();
      final authState = authCubit.state;

      final currentLocation = state.matchedLocation;

      if (authState is AuthInitial) {
        return Routes.splash;
      }

      final isAuthenticated = authState is AuthAuthenticated;

      if (authState is AuthLoading) {
        final isGoingToSplash = currentLocation == Routes.splash;
        return isGoingToSplash ? null : Routes.splash;
      }

      if (authState is AuthError) {
        final isGoingToLogin = currentLocation == Routes.login;
        return isGoingToLogin ? null : Routes.login;
      }

      final isGoingToLogin = currentLocation == Routes.login;
      final isGoingToSplash = currentLocation == Routes.splash;

      if (isGoingToSplash && authState is! AuthLoading) {
        return isAuthenticated ? Routes.home : Routes.login;
      }

      if (!isAuthenticated) {
        return isGoingToLogin ? null : Routes.login;
      }

      if (isAuthenticated && isGoingToLogin) {
        return Routes.home;
      }

      return null;
    },
    routes: [
      // Auth routes
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Main stateful shell with bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Home branch
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Profile branch
          StatefulShellBranch(
            navigatorKey: _profileNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.profile,
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),

          // Settings branch
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: Routes.settings,
                name: 'settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider.value(
      value: di.sl<AuthCubit>(),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
          showUnselectedLabels: true,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}