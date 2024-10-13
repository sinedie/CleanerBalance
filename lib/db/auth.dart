import 'package:clear_balance/db/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future loginWithEmail(String email, String password) async {
  final AuthResponse res = await supabase.auth.signInWithPassword(
    email: email,
    password: password,
  );
  final User? user = res.user;
  return user;
}
