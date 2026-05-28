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
import 'package:flutter/services.dart';
import '../../models/openvpn_dropdown_option.dart';

/// Role selector widget for OpenVPN instances
class OpenvpnRoleSelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final String? helperText;

  const OpenvpnRoleSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Role',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment<String>(
                  value: 'server',
                  label: Text('Server'),
                  icon: Icon(Icons.dns),
                ),
                ButtonSegment<String>(
                  value: 'client',
                  label: Text('Client'),
                  icon: Icon(Icons.vpn_lock),
                ),
              ],
              selected: {value},
              onSelectionChanged: enabled ? (Set<String> newSelection) {
                onChanged(newSelection.first);
              } : null,
            ),
            if (helperText != null) ...[
              const SizedBox(height: 8),
              Text(
                helperText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Text field widget for OpenVPN forms
class OpenvpnTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const OpenvpnTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: validator,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
    );
  }
}

/// Password field widget with show/hide toggle
class OpenvpnPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const OpenvpnPasswordField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.enabled = true,
  });

  @override
  State<OpenvpnPasswordField> createState() => _OpenvpnPasswordFieldState();
}

class _OpenvpnPasswordFieldState extends State<OpenvpnPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
      obscureText: _obscureText,
      validator: widget.validator,
      enabled: widget.enabled,
    );
  }
}

/// Toggle switch field for boolean values
class OpenvpnToggleField extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const OpenvpnToggleField({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: enabled ? onChanged : null,
    );
  }
}

/// Dropdown field for single selection
class OpenvpnDropdownField extends StatelessWidget {
  final String labelText;
  final String? helperText;
  final IconData? prefixIcon;
  final Map<String, OpenvpnDropdownOption> options;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const OpenvpnDropdownField({
    super.key,
    required this.labelText,
    this.helperText,
    this.prefixIcon,
    required this.options,
    this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    // Build dropdown items, handling optgroups
    final List<DropdownMenuItem<String>> items = [];
    
    for (var entry in options.entries) {
      final option = entry.value;
      
      if (option.optgroup != null) {
        // This is an optgroup header - add as disabled item
        items.add(DropdownMenuItem<String>(
          value: null,
          enabled: false,
          child: Text(
            option.optgroup!,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ));
      } else {
        items.add(DropdownMenuItem<String>(
          value: entry.key,
          child: Padding(
            padding: EdgeInsets.only(left: option.optgroup != null ? 16.0 : 0),
            child: Text(
              option.value,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ));
      }
    }

    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      items: items,
      onChanged: enabled ? onChanged : null,
    );
  }
}

/// Multi-select field with chips display
class OpenvpnMultiSelectField extends StatelessWidget {
  final String labelText;
  final String? helperText;
  final IconData? prefixIcon;
  final Map<String, OpenvpnDropdownOption> options;
  final List<String> selectedValues;
  final ValueChanged<List<String>> onChanged;
  final bool enabled;

  const OpenvpnMultiSelectField({
    super.key,
    required this.labelText,
    this.helperText,
    this.prefixIcon,
    required this.options,
    required this.selectedValues,
    required this.onChanged,
    this.enabled = true,
  });

  Future<void> _showSelectionDialog(BuildContext context) async {
    final selected = List<String>.from(selectedValues);

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Select $labelText'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: options.entries.map((entry) {
                final option = entry.value;
                final isSelected = selected.contains(entry.key);

                return CheckboxListTile(
                  title: Text(option.value),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selected.add(entry.key);
                      } else {
                        selected.remove(entry.key);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                onChanged(selected);
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: enabled ? () => _showSelectionDialog(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: labelText,
              helperText: helperText,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            child: selectedValues.isEmpty
                ? const Text('None selected', style: TextStyle(color: Colors.grey))
                : Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedValues.map((value) {
                      final option = options[value];
                      return Chip(
                        label: Text(option?.value ?? value),
                        onDeleted: enabled ? () {
                          final updated = List<String>.from(selectedValues);
                          updated.remove(value);
                          onChanged(updated);
                        } : null,
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Array field manager for lists of strings (routes, DNS servers, etc.)
class OpenvpnArrayField extends StatelessWidget {
  final String title;
  final List<String> items;
  final VoidCallback onAdd;
  final Function(int) onRemove;
  final Function(int, String) onUpdate;
  final bool enabled;
  final String emptyMessage;
  final String? helperText;
  final String? Function(String)? validator;

  const OpenvpnArrayField({
    super.key,
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
    this.enabled = true,
    this.emptyMessage = 'No items configured',
    this.helperText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: enabled ? onAdd : null,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Text(
            helperText!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              emptyMessage,
              style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          )
        else
          ...List.generate(items.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: items[index],
                      decoration: InputDecoration(
                        labelText: '${title.split(' ').last} ${index + 1}',
                        border: const OutlineInputBorder(),
                      ),
                      enabled: enabled,
                      onChanged: (value) => onUpdate(index, value),
                      validator: validator != null ? (value) => validator!(value ?? '') : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: enabled ? () => onRemove(index) : null,
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

/// Section container for grouping form fields
class FormSectionContainer extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;

  const FormSectionContainer({
    super.key,
    required this.title,
    required this.children,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}



/// CIDR field widget with IPv4/IPv6 validation
class OpenvpnCidrField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final String? helperText;
  final IconData? prefixIcon;
  final bool enabled;
  final CidrVersion version;

  const OpenvpnCidrField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.helperText,
    this.prefixIcon,
    this.enabled = true,
    this.version = CidrVersion.auto,
  });

  /// Validate IPv4 address format
  static bool _isValidIPv4(String ip) {
    if (ip.isEmpty) return false;
    
    final parts = ip.split('.');
    if (parts.length != 4) return false;
    
    for (final part in parts) {
      final num = int.tryParse(part);
      if (num == null || num < 0 || num > 255) {
        return false;
      }
    }
    
    return true;
  }

  /// Validate IPv6 address format
  static bool _isValidIPv6(String ip) {
    if (ip.isEmpty) return false;
    
    // IPv6 regex pattern (simplified but covers most cases)
    final ipv6Pattern = RegExp(
      r'^(([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,7}:|'
      r'([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|'
      r'([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|'
      r'([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|'
      r'([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|'
      r'[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|'
      r':((:[0-9a-fA-F]{1,4}){1,7}|:)|'
      r'fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|'
      r'::(ffff(:0{1,4}){0,1}:){0,1}'
      r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}'
      r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|'
      r'([0-9a-fA-F]{1,4}:){1,4}:'
      r'((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3}'
      r'(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$'
    );
    
    return ipv6Pattern.hasMatch(ip);
  }

  /// Validate CIDR notation
  String? _validateCidr(String? value) {
    if (value == null || value.isEmpty) {
      return 'CIDR notation is required';
    }

    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Invalid CIDR notation (use format: IP/prefix)';
    }

    final ip = parts[0].trim();
    final prefixStr = parts[1].trim();
    final prefix = int.tryParse(prefixStr);

    if (prefix == null) {
      return 'Invalid prefix length';
    }

    // Auto-detect IP version or validate based on specified version
    bool isIPv4 = _isValidIPv4(ip);
    bool isIPv6 = _isValidIPv6(ip);

    switch (version) {
      case CidrVersion.ipv4:
        if (!isIPv4) {
          return 'Invalid IPv4 address';
        }
        if (prefix < 0 || prefix > 32) {
          return 'Invalid IPv4 prefix (must be 0-32)';
        }
        break;

      case CidrVersion.ipv6:
        if (!isIPv6) {
          return 'Invalid IPv6 address';
        }
        if (prefix < 0 || prefix > 128) {
          return 'Invalid IPv6 prefix (must be 0-128)';
        }
        break;

      case CidrVersion.auto:
        if (isIPv4) {
          if (prefix < 0 || prefix > 32) {
            return 'Invalid IPv4 prefix (must be 0-32)';
          }
        } else if (isIPv6) {
          if (prefix < 0 || prefix > 128) {
            return 'Invalid IPv6 prefix (must be 0-128)';
          }
        } else {
          return 'Invalid IP address (must be IPv4 or IPv6)';
        }
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText ?? _getDefaultHint(),
        helperText: helperText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      validator: _validateCidr,
      enabled: enabled,
      keyboardType: TextInputType.text,
      maxLines: 1,
    );
  }

  String _getDefaultHint() {
    switch (version) {
      case CidrVersion.ipv4:
        return '10.8.0.0/24';
      case CidrVersion.ipv6:
        return 'fd00::/64';
      case CidrVersion.auto:
        return '10.8.0.0/24 or fd00::/64';
    }
  }
}

/// CIDR version enum for specifying IP version
enum CidrVersion {
  /// IPv4 only (0-32 prefix)
  ipv4,
  
  /// IPv6 only (0-128 prefix)
  ipv6,
  
  /// Auto-detect from input
  auto,
}
