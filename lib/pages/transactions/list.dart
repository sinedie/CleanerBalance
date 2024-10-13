import 'package:clear_balance/pages/transactions/components/account_dropdown.dart';
import 'package:clear_balance/pages/transactions/components/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key, required this.title});

  final String title;

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late String account = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              context.go("/transactions/settings");
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AccountDropdown(
              value: account,
              onChange: (newCategory) {
                setState(() {
                  account = newCategory;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: TransactionsList(
                account: account,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/transactions/create");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
