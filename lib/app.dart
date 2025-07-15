import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_delivery_mobile/config/routes/router_config.dart';
import 'package:pos_delivery_mobile/core/di/di.dart' as di;
import 'package:pos_delivery_mobile/features/auth/presentation/bloc/auth_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => di.sl<AuthCubit>(),
        ),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, current) {
          if (previous.runtimeType == current.runtimeType) return false;
          
          return _shouldRefreshRouter(previous, current);
        },
        listener: (context, state) {
          AppRouter.router.refresh();
        },
        child: MaterialApp.router(
          title: 'POS Delivery',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }

  bool _shouldRefreshRouter(AuthState previous, AuthState current) {
    return (previous is AuthInitial && current is AuthLoading) ||
           (previous is AuthLoading && current is AuthAuthenticated) ||
           (previous is AuthLoading && current is AuthUnauthenticated) ||
           (previous is AuthLoading && current is AuthError) ||
           (previous is AuthAuthenticated && current is AuthUnauthenticated) ||
           (previous is AuthUnauthenticated && current is AuthAuthenticated) ||
           (previous is AuthError && current is AuthAuthenticated) ||
           (previous is AuthError && current is AuthUnauthenticated);
  }
}