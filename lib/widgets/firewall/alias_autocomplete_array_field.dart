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
import '../../l10n/app_localizations.dart';
import '../../utils/app_colors.dart';

/// An array field where each row is a free-text input with inline autocomplete
/// suggestions drawn from [suggestions] (alias name → alias name).
///
/// Selecting a suggestion pre-fills the row's text field with the alias name,
/// but the field remains editable so the user can further modify the value.
/// The user may also type any free-text value without picking a suggestion.
class AliasAutocompleteArrayField extends StatefulWidget {
  final List<String> items;

  /// Map of alias name → alias name used as autocomplete suggestions.
  /// Suggestions are shown when the query matches (case-insensitive) any part
  /// of the key (alias name).
  final Map<String, String> suggestions;

  final VoidCallback onAdd;
  final void Function(int index) onRemove;
  final void Function(int index, String value) onUpdate;
  final bool enabled;
  final String emptyMessage;
  final String? helperText;
  final String title;

  const AliasAutocompleteArrayField({
    super.key,
    required this.items,
    required this.suggestions,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
    required this.title,
    this.enabled = true,
    this.emptyMessage = 'No items configured',
    this.helperText,
  });

  @override
  State<AliasAutocompleteArrayField> createState() =>
      _AliasAutocompleteArrayFieldState();
}

class _AliasAutocompleteArrayFieldState
    extends State<AliasAutocompleteArrayField> {
  /// One controller per row, kept in sync with [widget.items].
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(AliasAutocompleteArrayField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers(oldWidget);
  }

  /// Brings [_controllers] fully in sync with [widget.items].
  ///
  /// [oldWidget] is used to detect externally-driven item changes (e.g.
  /// loadFullAlias completing). A controller's text is only overwritten when
  /// the parent changed the item value itself — not when the user typed it
  /// (which would already be reflected in both the controller and widget.items
  /// via the onChanged → setState round-trip).
  void _syncControllers([AliasAutocompleteArrayField? oldWidget]) {
    // 1. Dispose and remove controllers beyond the new length.
    for (var i = widget.items.length; i < _controllers.length; i++) {
      _controllers[i].dispose();
    }
    if (_controllers.length > widget.items.length) {
      _controllers.removeRange(widget.items.length, _controllers.length);
    }

    // 2. Add controllers for newly appended items.
    for (var i = _controllers.length; i < widget.items.length; i++) {
      _controllers.add(TextEditingController(text: widget.items[i]));
    }

    // 3. Only overwrite a controller's text when the parent changed the item
    //    value externally (oldWidget.items[i] != widget.items[i]). This avoids
    //    clobbering text mid-keystroke on the user-typing rebuild path.
    if (oldWidget != null) {
      for (var i = 0; i < _controllers.length; i++) {
        final oldValue = i < oldWidget.items.length ? oldWidget.items[i] : null;
        final newValue = widget.items[i];
        if (oldValue != newValue && _controllers[i].text != newValue) {
          _controllers[i].text = newValue;
          _controllers[i].selection =
              TextSelection.collapsed(offset: newValue.length);
        }
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: widget.enabled ? widget.onAdd : null,
              icon: const Icon(Icons.add, size: 18),
              label: Text(l10n.add),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        if (widget.helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
        const SizedBox(height: 8),
        if (widget.items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              widget.emptyMessage,
              style: const TextStyle(
                  color: AppColors.disabled, fontStyle: FontStyle.italic),
            ),
          )
        else
          ...List.generate(widget.items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: _AutocompleteRow(
                controller: _controllers[index],
                suggestions: widget.suggestions,
                labelText: '${widget.title.split(' ').last} ${index + 1}',
                enabled: widget.enabled,
                onChanged: (v) => widget.onUpdate(index, v),
                onRemove: () => widget.onRemove(index),
              ),
            );
          }),
      ],
    );
  }
}

/// A single row: a [TextFormField] with an inline autocomplete overlay.
///
/// Must be a [StatefulWidget] so [FocusNode] is created once and lives for
/// the lifetime of the row — creating it inside [build] would produce a new
/// unfocused node on every rebuild, stealing focus after each keystroke.
class _AutocompleteRow extends StatefulWidget {
  final TextEditingController controller;
  final Map<String, String> suggestions;
  final String labelText;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback onRemove;

  const _AutocompleteRow({
    required this.controller,
    required this.suggestions,
    required this.labelText,
    required this.enabled,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  State<_AutocompleteRow> createState() => _AutocompleteRowState();
}

class _AutocompleteRowState extends State<_AutocompleteRow> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RawAutocomplete<String>(
            textEditingController: widget.controller,
            focusNode: _focusNode,
            optionsBuilder: (TextEditingValue textEditingValue) {
              final query = textEditingValue.text.toLowerCase();
              if (query.isEmpty) return const Iterable<String>.empty();
              return widget.suggestions.keys
                  .where((name) => name.toLowerCase().contains(query))
                  .take(8);
            },
            onSelected: (String selection) {
              widget.controller.text = selection;
              widget.controller.selection =
                  TextSelection.collapsed(offset: selection.length);
              widget.onChanged(selection);
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController fieldController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return TextFormField(
                controller: fieldController,
                focusNode: fieldFocusNode,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  border: const OutlineInputBorder(),
                ),
                onChanged: widget.onChanged,
              );
            },
            optionsViewBuilder: (
              BuildContext context,
              AutocompleteOnSelected<String> onSelected,
              Iterable<String> options,
            ) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(4),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 200),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Text(option),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete, color: AppColors.error),
          onPressed: widget.enabled ? widget.onRemove : null,
        ),
      ],
    );
  }
}
