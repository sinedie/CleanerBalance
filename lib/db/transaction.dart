import 'package:clear_balance/db/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Transaction {
  static String table = "transaction";

  String? id;
  dynamic amount;
  bool expense;
  String date;
  String account;
  String? category;
  String? notes;
  DateTime? created_at = DateTime.now();
  DateTime? updated_at = DateTime.now();
  // DateTime? created_by;

  Transaction({
    this.id,
    required this.amount,
    required this.expense,
    required this.date,
    required this.account,
    this.category,
    this.notes,
    this.created_at,
    this.updated_at,
    // this.created_by,
  });

  // static getStats(String account) {
  //   return supabase
  //       .from(table)
  //       .select("amount.min(), amount.max(), amount.avg()")
  //       .count();
  // }

  static PostgrestTransformBuilder<PostgrestList> getList(String account) {
    if (account != "") {
      return supabase
          .from(table)
          .select()
          .eq("account", account)
          .order("amount", ascending: false);
    }
    return supabase.from(table).select().order("amount", ascending: false);
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> get(
      String transactionId) {
    return supabase.from(table).select().eq("id", transactionId).single();
  }

  static PostgrestTransformBuilder<Map<String, dynamic>> create(
      Transaction transaction) {
    return supabase.from(table).insert(transaction.toJson()).select().single();
  }

  static update(String transactionId, Transaction transaction) {
    return supabase
        .from(table)
        .update(transaction.toJson())
        .eq("id", transactionId);
  }

  static delete(String transactionId) {
    return supabase.from(table).delete().eq("id", transactionId);
  }

  toJson() {
    var data = {
      "amount": amount,
      "expense": expense,
      "notes": notes,
      "date": date,
      "account": account,
      "category": category,
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
