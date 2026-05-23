/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';

/// Reusable widget for managing lists of items (tunnel addresses, DNS servers, etc.)
class ListManagerCard extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onAdd;
  final Function(String) onRemove;
  final bool isLoading;
  final String emptyMessage;

  const ListManagerCard({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onRemove,
    this.isLoading = false,
    this.emptyMessage = 'No items configured',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          Text(
            emptyMessage,
            style: const TextStyle(color: Colors.grey),
          )
        else
          ...items.map((item) => Card(
                child: ListTile(
                  title: Text(item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: isLoading ? null : () => onRemove(item),
                  ),
                ),
              )),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: isLoading ? null : onAdd,
          icon: const Icon(Icons.add),
          label: Text('Add ${title.split(' ').last}'),
        ),
      ],
    );
  }
}

/// Dialog for adding a single text item
class AddItemDialog extends StatelessWidget {
  final String title;
  final String labelText;
  final String hintText;
  final String? helperText;
  final String? Function(String) validator;

  const AddItemDialog({
    super.key,
    required this.title,
    required this.labelText,
    required this.hintText,
    this.helperText,
    required this.validator,
  });

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String labelText,
    required String hintText,
    String? helperText,
    required String? Function(String) validator,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AddItemDialog(
        title: title,
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final value = controller.text.trim();
            final error = validator(value);
            
            if (error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              Navigator.of(context).pop(value);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}


