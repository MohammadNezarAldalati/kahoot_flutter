import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context, String entityName) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Confirm Delete'),
      content: Text('Are you sure you want to delete this $entityName? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  return result ?? false;
}
