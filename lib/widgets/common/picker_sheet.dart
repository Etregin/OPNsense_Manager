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

class PickerSheet extends StatefulWidget {
  final String title;
  final Map<String, String> options;
  final List<String> initialSelected;
  final bool isLoading;
  final String searchHint;
  final String doneLabel;
  final String emptyLabel;
  /// When true, shows the option key as a subtitle (useful for net options).
  final bool showSubtitle;
  /// When true, tapping an item immediately selects it and closes the sheet
  /// (radio-button behaviour). The Done button is hidden.
  final bool singleSelect;
  final ValueChanged<List<String>> onDone;

  const PickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.isLoading,
    required this.searchHint,
    required this.doneLabel,
    required this.emptyLabel,
    required this.showSubtitle,
    required this.onDone,
    this.singleSelect = false,
  });

  @override
  State<PickerSheet> createState() => PickerSheetState();
}

class PickerSheetState extends State<PickerSheet> {
  late final TextEditingController _searchCtrl;
  late List<String> _working;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _working = List<String>.from(widget.initialSelected);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchCtrl.text.toLowerCase();
    final filtered = widget.options.entries
        .where((e) =>
            e.key.toLowerCase().contains(query) ||
            e.value.toLowerCase().contains(query))
        .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // Handle bar
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              widget.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                border: const OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.options.isEmpty
                    ? Center(child: Text(widget.emptyLabel))
                    : ListView.builder(
                        controller: scrollCtrl,
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final e = filtered[i];
                          final isSelected = _working.contains(e.key);
                          if (widget.singleSelect) {
                            return ListTile(
                              dense: true,
                              selected: isSelected,
                              leading: Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                              title: Text(e.value),
                              subtitle: widget.showSubtitle && e.key != e.value
                                  ? Text(e.key,
                                      style: Theme.of(context).textTheme.bodySmall)
                                  : null,
                              onTap: () {
                                widget.onDone([e.key]);
                                Navigator.of(context).pop();
                              },
                            );
                          }
                          return CheckboxListTile(
                            dense: true,
                            value: isSelected,
                            title: Text(e.value),
                            subtitle: widget.showSubtitle && e.key != e.value
                                ? Text(e.key,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                                : null,
                            onChanged: (v) => setState(() {
                              if (v == true) {
                                if (e.key == 'any') {
                                  _working
                                    ..clear()
                                    ..add('any');
                                } else {
                                  _working.remove('any');
                                  _working.add(e.key);
                                }
                              } else {
                                _working.remove(e.key);
                                if (_working.isEmpty) _working.add('any');
                              }
                            }),
                          );
                        },
                      ),
          ),
          if (!widget.singleSelect)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      widget.onDone(List<String>.from(_working));
                      Navigator.of(context).pop();
                    },
                    child: Text(widget.doneLabel),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
