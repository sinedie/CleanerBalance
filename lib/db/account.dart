import 'package:clear_balance/db/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Account {
  static String table = "account";

  String? id;
  String name;
  String? description = "";
  String? created_at;
  String? updated_at;
  // String? created_by;

  Account({
    this.id,
    required this.name,
    this.description,
    this.created_at,
    this.updated_at,
    // required this.created_by,
  });

  static count() {
    return supabase.from(table).count();
  }

  static PostgrestTransformBuilder<PostgrestList> getList() {
    return supabase.from(table).select().order("name", ascending: true);
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> get(String accountId) {
    return supabase.from(table).select().eq("id", accountId).single();
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> create(
      Account account) {
    return supabase.from(table).insert(account.toJson()).select().single();
  }

  static update(String accountId, Account account) {
    return supabase.from(table).update(account.toJson()).eq("id", accountId);
  }

  static delete(String accountId) {
    return supabase.from(table).delete().eq("id", accountId);
  }

  toJson() {
    var data = {
      "name": name,
      "description": description,
    };

    if (id != null) {
      data.addAll({
        "id": id,
        "created_at": created_at,
        "updated_at": updated_at,
        // "created_by": created_by,
      });
    }

    return data;
  }
}
