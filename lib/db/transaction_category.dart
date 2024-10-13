import 'package:clear_balance/db/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionCategory {
  static String table = "transaction_category";

  String? id;
  String name;
  String? description = "";
  String? created_at;
  String? updated_at;
  // String? created_by;

  TransactionCategory({
    this.id,
    required this.name,
    this.description,
    this.created_at,
    this.updated_at,
    // required this.created_by,
  });

  static PostgrestTransformBuilder<PostgrestList> getList() {
    return supabase.from(table).select().order("name", ascending: true);
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> get(
      String categoryId) {
    return supabase.from(table).select().eq("id", categoryId).single();
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> create(
      TransactionCategory category) {
    return supabase.from(table).insert(category.toJson()).select().single();
  }

  static update(String categoryId, TransactionCategory category) {
    return supabase.from(table).update(category.toJson()).eq("id", categoryId);
  }

  static delete(String categoryId) {
    return supabase.from(table).delete().eq("id", categoryId);
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
