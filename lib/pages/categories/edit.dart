import 'package:clear_balance/db/transaction_category.dart';
import 'package:clear_balance/utils/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryEditPage extends StatefulWidget {
  const CategoryEditPage({super.key, this.categoryId});

  final String? categoryId;

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> controllers = {
    'name': TextEditingController(text: ""),
    'description': TextEditingController(text: ""),
  };

  @override
  void initState() {
    if (widget.categoryId != null) {
      TransactionCategory.get(widget.categoryId!).then(
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
      TransactionCategory category = TransactionCategory(
        name: controllers['name']!.text,
        description: controllers['description']!.text,
      );

      if (widget.categoryId != null) {
        await TransactionCategory.update(widget.categoryId!, category);
      } else {
        await TransactionCategory.create(category);
      }
      context.pop();
      return;
    }

    showSnackBar(context, "Error while saving", type: "danger");
  }

  Future<void> onDelete() async {
    if (widget.categoryId != null) {
      await TransactionCategory.delete(widget.categoryId!);
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Create category"),
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
                if (widget.categoryId != null) {
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
