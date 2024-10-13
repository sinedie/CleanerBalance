import 'package:clear_balance/db/transaction_category.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';

class TransactionCategoryDropdown extends StatefulWidget {
  const TransactionCategoryDropdown({
    super.key,
    required this.value,
    required this.onChange,
    this.hasErrors = false,
  });

  final String value;
  final Function(dynamic) onChange;
  final bool? hasErrors;

  @override
  State<TransactionCategoryDropdown> createState() =>
      TransactionCategoryDropdownState();
}

class TransactionCategoryDropdownState
    extends State<TransactionCategoryDropdown> {
  final query = TransactionCategory.getList();
  List<Map<String, dynamic>> initialCategories = [];

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

        var categories = [];
        categories.addAll(initialCategories);
        if (snapshot.data != null) {
          categories.addAll(snapshot.data as Iterable);
        }

        return DropdownMenu<String>(
          label: const Text("Category"),
          errorText: widget.hasErrors == true ? "Select one category" : null,
          initialSelection: widget.value,
          leadingIcon: const Icon(Icons.category),
          expandedInsets: const EdgeInsets.all(0),
          onSelected: (String? value) {
            setState(() {
              widget.onChange(value);
            });
          },
          dropdownMenuEntries: categories
              .map((value) => DropdownMenuEntry<String>(
                  value: value['id']!, label: value['name']!))
              .toList(),
        );
      },
    );
  }
}
