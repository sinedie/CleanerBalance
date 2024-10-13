import 'package:clear_balance/db/account.dart';
import 'package:clear_balance/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountEditPage extends StatefulWidget {
  const AccountEditPage({super.key, this.accountId});

  final String? accountId;

  @override
  State<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> controllers = {
    'name': TextEditingController(text: ""),
    'description': TextEditingController(text: ""),
  };

  @override
  void initState() {
    if (widget.accountId != null) {
      Account.get(widget.accountId!).then(
        (value) {
          controllers['name'].text = value['name'] ?? "";
          controllers['description'].text = value['description'] ?? "";
        },
      );
    }

    super.initState();
  }

  String? _validateEmptyness(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid value';
    }
    return null;
  }

  Future<void> onSubmit() async {
    if (_formKey.currentState!.validate()) {
      Account account = Account(
        name: controllers['name']!.text,
        description: controllers['description']!.text,
      );

      if (widget.accountId != null) {
        await Account.update(widget.accountId!, account);
      } else {
        await Account.create(account);
      }
      context.pop();
      return;
    }

    showSnackBar(context, "Error while saving", type: "danger");
  }

  Future<void> onDelete() async {
    if (widget.accountId != null) {
      await Account.delete(widget.accountId!);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create account"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: onSubmit,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              TextFormField(
                controller: controllers['name'],
                validator: _validateEmptyness,
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextFormField(
                maxLines: 5,
                minLines: 1,
                controller: controllers['description'],
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              Builder(builder: (context) {
                if (widget.accountId != null) {
                  return MaterialButton(
                    minWidth: double.infinity,
                    height: 45,
                    onPressed: onDelete,
                    color: Colors.red,
                    child: const Text("Delete"),
                  );
                }
                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
