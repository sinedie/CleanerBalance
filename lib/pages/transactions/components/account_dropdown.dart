import 'package:clear_balance/db/account.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';

class AccountDropdown extends StatefulWidget {
  const AccountDropdown({
    super.key,
    required this.value,
    required this.onChange,
    this.showAll = true,
    this.hasErrors = false,
  });

  final bool? showAll;
  final bool? hasErrors;
  final String value;
  final Function(dynamic) onChange;

  @override
  State<AccountDropdown> createState() => AccountDropdownState();
}

class AccountDropdownState extends State<AccountDropdown> {
  final query = Account.getList();
  List<Map<String, dynamic>> initialAccounts = [];

  @override
  void initState() {
    if (widget.showAll == true) {
      initialAccounts.add({"id": "", "name": "All"});
    }

    Account.count().then((value) {
      if (value == 0) {
        Account newAccount = Account(name: "General");
        Account.create(newAccount).then((newValue) {
          setState(() {
            initialAccounts.add(newValue[0]);
          });
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }
        if (snapshot.hasError) {
          return const Text("An error happened while Downloading");
        }

        var accounts = [];
        accounts.addAll(initialAccounts);
        if (snapshot.data != null) {
          accounts.addAll(snapshot.data as Iterable);
        }

        return DropdownMenu<String>(
          initialSelection: widget.value,
          label: const Text("Account"),
          errorText: widget.hasErrors == true ? "Select one account" : null,
          leadingIcon: const Icon(Icons.account_balance),
          expandedInsets: const EdgeInsets.all(0),
          onSelected: (String? value) {
            setState(() {
              widget.onChange(value);
            });
          },
          dropdownMenuEntries: accounts
              .map((value) => DropdownMenuEntry<String>(
                  value: value['id']!, label: value['name']!))
              .toList(),
        );
      },
    );
  }
}
