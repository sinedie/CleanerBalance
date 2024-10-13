import 'package:clear_balance/db/transaction_category.dart';
import 'package:clear_balance/utils/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    Future<dynamic> query = TransactionCategory.getList();
    return FutureBuilder(
      future: query,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingIndicator();
        }
        final categories = snapshot.data!;
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: ((context, index) {
            final category = categories[index];
            return CategoryListTile(category: category);
          }),
        );
      },
    );
  }
}

class CategoryListTile extends StatefulWidget {
  const CategoryListTile({super.key, required this.category});

  final Map<String, dynamic> category;

  @override
  State<CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context
            .go("/transactions/settings/categories/${widget.category['id']}");
      },
      title: Text(widget.category['name']),
    );
  }
}
