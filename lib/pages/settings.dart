import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final List<Map<String, String>> settings = [
    {"label": "Manage accounts", "path": "/transactions/settings/accounts"},
    {
      "label": "Manage transaction categories",
      "path": "/transactions/settings/categories"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: settings.length,
          itemBuilder: ((context, index) {
            final setting = settings[index];
            return ListTile(
              onTap: () {
                context.go(setting['path']!);
              },
              title: Text(setting['label']!),
            );
          }),
        ),
      ),
    );
  }
}
