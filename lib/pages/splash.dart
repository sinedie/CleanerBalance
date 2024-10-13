import 'package:clear_balance/db/client.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.wait([
      supabase.auth.getUser(),
    ]).then((responseList) {
      final user = responseList.first as User?;

      if (context.mounted) {
        context.go(user != null ? "/transactions" : "/login");
      }
    }).catchError((_) {
      if (context.mounted) {
        context.go("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: LoadingIndicator(),
      ),
    );
  }
}
