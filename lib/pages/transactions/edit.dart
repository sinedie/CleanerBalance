import 'package:clear_balance/db/transaction.dart';
import 'package:clear_balance/pages/transactions/components/account_dropdown.dart';
import 'package:clear_balance/pages/transactions/components/categories_dropdown.dart';
import 'package:clear_balance/utils/format.dart';
import 'package:clear_balance/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionEditPage extends StatefulWidget {
  const TransactionEditPage({super.key, this.transactionId});

  final String? transactionId;

  @override
  State<TransactionEditPage> createState() => _TransactionEditPageState();
}

class _TransactionEditPageState extends State<TransactionEditPage> {
  final _formKey = GlobalKey<FormState>();
  bool touched = false;
  bool expense = false;

  final Map<String, dynamic> controllers = {
    'notes': TextEditingController(text: ""),
    'amount': TextEditingController(text: ""),
    'account': TextEditingController(text: ""),
    'category': TextEditingController(text: ""),
    'date': TextEditingController(text: parseDate(DateTime.now())),
  };

  @override
  void initState() {
    if (widget.transactionId != null) {
      Transaction.get(widget.transactionId!).then((value) {
        expense = value['expense'];
        controllers['notes'].text = value['notes'] ?? "";
        controllers['amount'].text = "${value['amount'] ?? ""}";
        controllers['date'].text = value['date'] ?? "";
        controllers['account'].text = value['account'] ?? "";
        controllers['category'].text = value['category'] ?? "";
      });
    }

    super.initState();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().add(const Duration(days: -30)),
      lastDate: DateTime.now(),
    );
    if (picked != null && parseDate(picked) != controllers['date']!.text) {
      setState(() {
        controllers['date']!.text = parseDate(picked);
      });
    }
  }

  String? _validateEmptyness(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid value';
    }
    return null;
  }

  bool _validateForm() {
    return _formKey.currentState!.validate() &&
        controllers['account']!.text != "" &&
        controllers['category']!.text != "";
  }

  Future<void> onSubmit() async {
    if (_validateForm()) {
      Transaction transaction = Transaction(
        amount: controllers['amount']!.text,
        date: controllers['date']!.text,
        expense: false,
        account: controllers['account']!.text,
        category: controllers['category']!.text,
      );

      if (widget.transactionId != null) {
        await Transaction.update(widget.transactionId!, transaction);
      } else {
        await Transaction.create(transaction);
      }
      context.pop();
      return;
    }

    setState(() {
      touched = true;
    });
    showSnackBar(context, "Error while saving", type: "danger");
  }

  Future<void> onDelete() async {
    if (widget.transactionId != null) {
      await Transaction.delete(widget.transactionId!);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create transaction"),
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
              AccountDropdown(
                value: controllers['account']!.text,
                showAll: false,
                hasErrors: touched && controllers['account']!.text == "",
                onChange: (value) {
                  setState(() {
                    controllers['account'].text = value;
                  });
                },
              ),
              TransactionCategoryDropdown(
                value: controllers['category']!.text,
                hasErrors: touched && controllers['category']!.text == "",
                onChange: (value) {
                  setState(() {
                    controllers['category'].text = value;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mark as expense",
                    style: TextStyle(fontSize: 15),
                  ),
                  Switch(
                    value: expense,
                    onChanged: (value) {
                      setState(() {
                        expense = value;
                      });
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: controllers['amount'],
                validator: _validateEmptyness,
                decoration: const InputDecoration(
                  labelText: "Amount",
                ),
              ),
              TextFormField(
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                controller: controllers['date'],
                validator: _validateEmptyness,
                decoration: const InputDecoration(
                  labelText: "Date",
                ),
              ),
              TextFormField(
                maxLines: 5,
                minLines: 1,
                controller: controllers['notes'],
                decoration: const InputDecoration(
                  labelText: "notes",
                ),
              ),
              Builder(builder: (context) {
                if (widget.transactionId != null) {
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
