import 'package:clear_balance/db/transaction.dart';
import 'package:clear_balance/utils/format.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key, required this.account});

  final String account;

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> query = Transaction.getList(widget.account);
    return FutureBuilder(
      future: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }
        final transactions = snapshot.data!;
        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: ((context, index) {
            final transaction = transactions[index];
            return TransactionListTile(transaction: transaction);
          }),
        );
      },
    );
  }
}

class TransactionListTile extends StatefulWidget {
  const TransactionListTile({super.key, required this.transaction});

  final Map<String, dynamic> transaction;

  @override
  State<TransactionListTile> createState() => _TransactionListTileState();
}

class _TransactionListTileState extends State<TransactionListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go("/transactions/${widget.transaction['id']}");
      },
      subtitle: Text(
        widget.transaction['date'].split("T")[0],
        style: const TextStyle(
          color: Color.fromARGB(95, 158, 158, 158),
        ),
      ),
      title: Text(
        formatAsCurrency(widget.transaction['amount'], "COP"),
        style: TextStyle(
          color: widget.transaction['expense']
              ? const Color.fromARGB(174, 255, 55, 55)
              : const Color.fromARGB(95, 55, 255, 138),
        ),
      ),
    );
  }
}
