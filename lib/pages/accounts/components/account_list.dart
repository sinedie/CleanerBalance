import 'package:clear_balance/db/account.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountsList extends StatefulWidget {
  const AccountsList({super.key});

  @override
  State<AccountsList> createState() => _AccountsListState();
}

class _AccountsListState extends State<AccountsList> {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> query = Account.getList();
    return FutureBuilder(
      future: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }
        final accounts = snapshot.data!;
        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: ((context, index) {
            final account = accounts[index];
            return AccountListTile(account: account);
          }),
        );
      },
    );
  }
}

class AccountListTile extends StatefulWidget {
  const AccountListTile({super.key, required this.account});

  final Map<String, dynamic> account;

  @override
  State<AccountListTile> createState() => _AccountListTileState();
}

class _AccountListTileState extends State<AccountListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.go("/transactions/settings/accounts/${widget.account['id']}");
      },
      title: Text(widget.account['name']),
    );
  }
}
