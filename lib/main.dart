import 'dart:ui';
import 'package:clear_balance/pages/accounts/edit.dart';
import 'package:clear_balance/pages/accounts/list.dart';
import 'package:clear_balance/pages/categories/edit.dart';
import 'package:clear_balance/pages/categories/list.dart';
import 'package:clear_balance/pages/login.dart';
import 'package:clear_balance/pages/settings.dart';
import 'package:clear_balance/pages/splash.dart';
import 'package:clear_balance/pages/transactions/edit.dart';
import 'package:go_router/go_router.dart';

import 'package:clear_balance/pages/transactions/list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: const String.fromEnvironment("SUPABASE_URL"),
    anonKey: const String.fromEnvironment("SUPABASE_PUBLIC_ANON_KEY"),
  );

  runApp(const ClearBalanceApp());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/transactions',
      builder: (BuildContext context, GoRouterState state) {
        return TransactionListPage(
          key: UniqueKey(),
          title: 'Cleaner Balance',
        );
      },
      routes: [
        GoRoute(
          path: 'create',
          builder: (BuildContext context, GoRouterState state) {
            return const TransactionEditPage();
          },
        ),
        GoRoute(
          path: "settings",
          builder: (BuildContext context, GoRouterState state) {
            return SettingsPage();
          },
          routes: [
            GoRoute(
              path: "accounts",
              builder: (BuildContext context, GoRouterState state) {
                return AccountListPage(
                  key: UniqueKey(),
                );
              },
              routes: [
                GoRoute(
                  path: "create",
                  builder: (BuildContext context, GoRouterState state) {
                    return const AccountEditPage();
                  },
                ),
                GoRoute(
                  path: ":account_id",
                  builder: (BuildContext context, GoRouterState state) {
                    return AccountEditPage(
                      accountId: state.pathParameters["account_id"]!,
                    );
                  },
                )
              ],
            ),
            GoRoute(
              path: "categories",
              builder: (BuildContext context, GoRouterState state) {
                return CategoryListPage(
                  key: UniqueKey(),
                );
              },
              routes: [
                GoRoute(
                  path: "create",
                  builder: (BuildContext context, GoRouterState state) {
                    return const CategoryEditPage();
                  },
                ),
                GoRoute(
                  path: ":category_id",
                  builder: (BuildContext context, GoRouterState state) {
                    return CategoryEditPage(
                      categoryId: state.pathParameters["category_id"]!,
                    );
                  },
                )
              ],
            )
          ],
        ),
        GoRoute(
          path: ":transaction_id",
          builder: (BuildContext context, GoRouterState state) {
            return TransactionEditPage(
              transactionId: state.pathParameters["transaction_id"]!,
            );
          },
        ),
      ],
    ),
  ],
);

class ClearBalanceApp extends StatelessWidget {
  const ClearBalanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Clear Balance',
      scrollBehavior: AppScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color.fromARGB(95, 55, 255, 138),
        ),
      ),
      darkTheme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          isDense: true,
        ),
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color.fromARGB(95, 55, 255, 138),
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
