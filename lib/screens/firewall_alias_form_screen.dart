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
import 'package:provider/provider.dart';
import '../models/firewall_alias.dart';
import '../utils/constants.dart';
import '../utils/snackbar_helper.dart';
import '../l10n/app_localizations.dart';
import '../services/demo_api_service.dart';
import '../viewmodels/firewall_alias_form_view_model.dart';
import '../widgets/common/confirmation_dialog.dart';
import '../widgets/common/form_section_container.dart';
import '../widgets/common/loading_overlay.dart';
import '../widgets/common/picker_sheet.dart';
import '../widgets/openvpn/openvpn_form_field_widgets.dart' show OpenvpnArrayField;

// ─────────────────────────────────────────────────────────────────────────────
// Alias type display labels
// ─────────────────────────────────────────────────────────────────────────────
const _kAliasTypes = <String, String>{
  'host':         'Host(s)',
  'network':      'Network(s)',
  'port':         'Port(s)',
  'url':          'URL (IPs)',
  'urltable':     'URL Table (IPs)',
  'urljson':      'URL Table in JSON format (IPs)',
  'geoip':        'GeoIP',
  'networkgroup': 'Network Group',
  'mac':          'MAC Address',
  'asn':          'BGP ASN',
  'dynipv6host':  'Dynamic IPv6 Host',
  'authgroup':    'OpenVPN Group',
  'internal':     'Internal (automatic)',
  'external':     'External (advanced)',
};

// ─────────────────────────────────────────────────────────────────────────────

/// Form screen for creating or editing a firewall alias.
class FirewallAliasFormScreen extends StatefulWidget {
  final FirewallAlias? alias;

  const FirewallAliasFormScreen({super.key, this.alias});

  bool get isEditing => alias != null;

  @override
  State<FirewallAliasFormScreen> createState() =>
      _FirewallAliasFormScreenState();
}

class _FirewallAliasFormScreenState extends State<FirewallAliasFormScreen> {
  late FirewallAliasFormViewModel _viewModel;
  final _formKey = GlobalKey<FormState>();

  // ── Text controllers ────────────────────────────────────────────────────────
  final _nameController         = TextEditingController();
  final _refreshDaysController  = TextEditingController();
  final _refreshHoursController = TextEditingController();
  final _pathExpressionController = TextEditingController();
  final _expireController       = TextEditingController();
  final _descriptionController  = TextEditingController();
  // Authorization extra fields (Sub-Task 6)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // ── Always-visible state ────────────────────────────────────────────────────
  bool _enabled = true;
  List<String> _selectedCategories = [];
  String _selectedType = 'host';
  bool _statistics = false;

  // ── Conditional state (populated in Sub-Task 6) ─────────────────────────────
  List<String> _contentItems = [];
  // GeoIP per-region selections: region label → list of country codes
  final Map<String, List<String>> _geoipSelections = {
    'Africa':     [],
    'America':    [],
    'Antarctica': [],
    'Arctic':     [],
    'Asia':       [],
    'Atlantic':   [],
    'Australia/Oceania': [],
    'Europe':     [],
    'Indian':     [],
    'Pacific':    [],
  };
  List<String> _selectedProto = ['IPv4', 'IPv6'];
  String _selectedInterface = '';
  String _selectedAuthtype = '';

  // Guard: populate form fields from alias only once
  bool _aliasDataLoaded = false;

  // ─────────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _viewModel = FirewallAliasFormViewModel(
      apiService: context.read<DemoApiService>(),
      existingAlias: widget.alias,
    );
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.loadFormData();
    if (widget.isEditing) {
      _viewModel.loadFullAlias(widget.alias!.uuid);
    }
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    _nameController.dispose();
    _refreshDaysController.dispose();
    _refreshHoursController.dispose();
    _pathExpressionController.dispose();
    _expireController.dispose();
    _descriptionController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (!mounted) return;

    // Populate form once the full alias has loaded.
    if (widget.isEditing &&
        !_aliasDataLoaded &&
        !_viewModel.loadingFullAlias) {
      final full = _viewModel.fullAlias;
      if (full != null) {
        _aliasDataLoaded = true;
        setState(() => _loadAliasData(full));
        return;
      }
    }

    setState(() {});
  }

  void _loadAliasData(FirewallAlias alias) {
    _nameController.text        = alias.name;
    _descriptionController.text = alias.description;
    _enabled    = alias.enabled == '1';
    _statistics = alias.counters == '1';
    _selectedType = alias.type.isNotEmpty ? alias.type : 'host';
    // categories: stored as comma-separated string
    if (alias.categories.isNotEmpty) {
      _selectedCategories =
          alias.categories.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }
    // Content — for GeoIP, parse "RegionName:code1,code2" lines into _geoipSelections.
    // For all other types, split newline-separated into _contentItems.
    if (alias.type == 'geoip') {
      for (final line in alias.content.split('\n').where((s) => s.isNotEmpty)) {
        final colonIdx = line.indexOf(':');
        if (colonIdx > 0) {
          final region = line.substring(0, colonIdx).trim();
          final codes  = line.substring(colonIdx + 1).split(',')
              .map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
          if (_geoipSelections.containsKey(region)) {
            _geoipSelections[region] = codes;
          }
        }
      }
    } else {
      _contentItems = alias.content.isNotEmpty
          ? alias.content.split('\n').where((s) => s.isNotEmpty).toList()
          : [];
    }
    // updatefreq: decimal string → days + hours
    final freq = double.tryParse(alias.updatefreq) ?? 0.0;
    if (freq > 0) {
      final days  = freq.truncate();
      final hours = ((freq - days) * 24).round();
      _refreshDaysController.text  = days > 0  ? days.toString()  : '';
      _refreshHoursController.text = hours > 0 ? hours.toString() : '';
    }
    _pathExpressionController.text = alias.pathExpression;
    _selectedInterface = alias.interface;
    _selectedProto = alias.proto.isNotEmpty
        ? alias.proto.split(',').map((s) => s.trim()).toList()
        : ['IPv4', 'IPv6'];
    // Authorization fields — only present in full alias loaded via get_item.
    if (alias.authtype.isNotEmpty) {
      _selectedAuthtype = alias.authtype;
    }
    _usernameController.text = alias.username;
    _passwordController.text = alias.password;
    _expireController.text   = alias.expire;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────────

  bool get _isLoading => _viewModel.isLoading;

  bool get _hasChanges {
    if (_nameController.text.isNotEmpty) return true;
    if (_descriptionController.text.isNotEmpty) return true;
    if (_selectedCategories.isNotEmpty) return true;
    if (_contentItems.isNotEmpty) return true;
    return false;
  }

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;
    final l10n = AppLocalizations.of(context)!;
    return ConfirmationDialog.show(
      context: context,
      title: l10n.unsavedChanges,
      message: l10n.unsavedChangesConfirmation,
      confirmText: l10n.discard,
      cancelText: l10n.cancel,
      isDestructive: true,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Save
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> _saveAlias() async {
    if (!_formKey.currentState!.validate()) return;

    // Build updatefreq string from days + hours inputs
    final daysStr  = _refreshDaysController.text.trim();
    final hoursStr = _refreshHoursController.text.trim();
    String? updatefreq;
    if (daysStr.isNotEmpty || hoursStr.isNotEmpty) {
      final days  = int.tryParse(daysStr)  ?? 0;
      final hours = int.tryParse(hoursStr) ?? 0;
      final total = days + hours / 24.0;
      updatefreq  = total.toStringAsFixed(6);
    }

    // For GeoIP, serialize _geoipSelections into "Region:code1,code2" lines.
    final String contentValue = _selectedType == 'geoip'
        ? _geoipSelections.entries
            .where((e) => e.value.isNotEmpty)
            .map((e) => '${e.key}:${e.value.join(',')}')
            .join('\n')
        : _contentItems.join('\n');

    final request = FirewallAliasRequest(
      name:          _nameController.text.trim(),
      type:          _selectedType,
      content:       contentValue,
      description:   _descriptionController.text.trim(),
      enabled:       _enabled ? '1' : '0',
      counters:      _statistics ? '1' : '0',
      proto:         _selectedProto.join(','),
      interface:     _selectedInterface,
      categories:    _selectedCategories.join(','),
      updatefreq:    updatefreq,
      pathExpression: _pathExpressionController.text.trim().isNotEmpty
          ? _pathExpressionController.text.trim()
          : null,
      authtype: _selectedAuthtype.isNotEmpty ? _selectedAuthtype : null,
      username: _usernameController.text.trim().isNotEmpty
          ? _usernameController.text.trim()
          : null,
      password: _passwordController.text.trim().isNotEmpty
          ? _passwordController.text.trim()
          : null,
      expire: _expireController.text.trim().isNotEmpty
          ? _expireController.text.trim()
          : null,
    );

    final success = await _viewModel.saveAlias(request);

    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      if (success) {
        final msg = widget.isEditing ? l10n.aliasUpdated : l10n.aliasCreated;
        Navigator.of(context).pop();
        SnackBarHelper.showSuccess(context, msg);
      } else {
        final err = _viewModel.errorMessage != null
            ? l10n.errorSavingAlias(_viewModel.errorMessage!)
            : l10n.errorSavingAlias('');
        SnackBarHelper.showError(context, err, duration: const Duration(seconds: 4));
      }
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Category picker field
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildCategoryPickerField() {
    final l10n = AppLocalizations.of(context)!;
    final categoryOpts = _viewModel.categories;

    Future<void> openPicker() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => PickerSheet(
          title: l10n.categoriesLabel,
          options: categoryOpts,
          initialSelected: _selectedCategories,
          isLoading: _viewModel.loadingFormData,
          searchHint: l10n.searchCategories,
          doneLabel: l10n.done,
          emptyLabel: l10n.noItemsConfigured,
          showSubtitle: false,
          onDone: (result) => setState(() => _selectedCategories = result),
        ),
      );
    }

    return InkWell(
      onTap: _isLoading ? null : openPicker,
      borderRadius: BorderRadius.circular(AppConstants.buttonBorderRadius),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.categoriesLabel,
          prefixIcon: const Icon(Icons.label_outline),
          suffixIcon: _viewModel.loadingFormData
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Icon(Icons.arrow_drop_down),
          helperText: l10n.categoriesHint,
          helperMaxLines: 2,
        ),
        child: _selectedCategories.isEmpty
            ? Text(l10n.categoriesHint,
                style: TextStyle(color: Theme.of(context).hintColor))
            : Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _selectedCategories.map((k) {
                  final label = categoryOpts[k] ?? k;
                  return Chip(
                    label: Text(label, style: const TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onDeleted: _isLoading
                        ? null
                        : () => setState(() => _selectedCategories.remove(k)),
                  );
                }).toList(),
              ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Visibility helpers
  // ─────────────────────────────────────────────────────────────────────────────

  bool get _showRefreshFrequency =>
      _selectedType == 'host' ||
      _selectedType == 'urltable' ||
      _selectedType == 'urljson';

  bool get _showPathExpression => _selectedType == 'urljson';

  bool get _showAuthorization =>
      _selectedType == 'host' ||
      _selectedType == 'url' ||
      _selectedType == 'urltable' ||
      _selectedType == 'urljson';

  bool get _showInterface => _selectedType == 'dynipv6host';

  bool get _showExpire => _selectedType == 'external';

  bool get _showProtoSelector =>
      _selectedType == 'geoip' || _selectedType == 'asn';

  // ─────────────────────────────────────────────────────────────────────────────
  // Conditional section builders
  // ─────────────────────────────────────────────────────────────────────────────

  /// Content section — switches on type for the right widget.
  Widget _buildContentSection() {
    final l10n = AppLocalizations.of(context)!;

    switch (_selectedType) {
      case 'geoip':
        return _buildGeoIpContentSection();

      case 'networkgroup':
        return _buildPickerContentSection(
          title: l10n.selectNetworkAliasesLabel,
          options: _viewModel.networkAliases,
        );

      case 'authgroup':
        return _buildPickerContentSection(
          title: l10n.selectVpnGroupsLabel,
          options: _viewModel.userGroups,
        );

      case 'external':
        // Read-only display of existing content
        return FormSectionContainer(
          title: l10n.content,
          children: [
            if (_contentItems.isEmpty)
              Text(l10n.noItemsConfigured,
                  style: const TextStyle(fontStyle: FontStyle.italic))
            else
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: _contentItems
                    .map((item) => Chip(label: Text(item,
                        style: const TextStyle(fontSize: 12))))
                    .toList(),
              ),
          ],
        );

      default:
        // Standard array field for: host, network, port, url, urltable,
        // urljson, mac, asn, dynipv6host, internal
        return FormSectionContainer(
          title: l10n.content,
          children: [
            OpenvpnArrayField(
              title: l10n.content,
              items: _contentItems,
              enabled: !_isLoading,
              emptyMessage: l10n.noItemsConfigured,
              helperText: l10n.aliasContentHint,
              onAdd: () => setState(() => _contentItems.add('')),
              onRemove: (i) => setState(() => _contentItems.removeAt(i)),
              onUpdate: (i, v) => setState(() => _contentItems[i] = v),
            ),
          ],
        );
    }
  }

  /// GeoIP region picker table.
  Widget _buildGeoIpContentSection() {
    final countries = _viewModel.countries;

    final l10n = AppLocalizations.of(context)!;
    return FormSectionContainer(
      title: l10n.geoipRegionsLabel,
      children: [
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(3),
          },
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(l10n.region,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(l10n.countries,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ..._geoipSelections.entries.map((entry) {
              final region   = entry.key;
              final selected = entry.value;
              return TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(region),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: _isLoading
                          ? null
                          : () async {
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                ),
                                builder: (_) => PickerSheet(
                                  title: l10n.selectCountriesLabel,
                                  options: countries,
                                  initialSelected: selected,
                                  isLoading: _viewModel.loadingFormData,
                                  searchHint: l10n.searchAliases,
                                  doneLabel: l10n.done,
                                  emptyLabel: l10n.noItemsConfigured,
                                  showSubtitle: false,
                                  onDone: (result) => setState(
                                      () => _geoipSelections[region] = result),
                                ),
                              );
                            },
                      child: selected.isEmpty
                          ? Text(l10n.noCountriesSelected,
                              style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontStyle: FontStyle.italic))
                          : Wrap(
                              spacing: 4,
                              runSpacing: 2,
                              children: selected.map((code) {
                                final name = countries[code] ?? code;
                                return Chip(
                                  label: Text(name,
                                      style: const TextStyle(fontSize: 11)),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                );
                              }).toList(),
                            ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  /// Picker-backed content section for networkgroup / authgroup.
  Widget _buildPickerContentSection({
    required String title,
    required Map<String, String> options,
  }) {
    final l10n = AppLocalizations.of(context)!;

    Future<void> openPicker() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => PickerSheet(
          title: title,
          options: options,
          initialSelected: _contentItems,
          isLoading: _viewModel.loadingFormData,
          searchHint: l10n.searchAliases,
          doneLabel: l10n.done,
          emptyLabel: l10n.noItemsConfigured,
          showSubtitle: false,
          onDone: (result) => setState(() => _contentItems = result),
        ),
      );
    }

    return FormSectionContainer(
      title: l10n.content,
      children: [
        InkWell(
          onTap: _isLoading ? null : openPicker,
          borderRadius:
              BorderRadius.circular(AppConstants.buttonBorderRadius),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: title,
              prefixIcon: const Icon(Icons.list_alt_outlined),
              suffixIcon: _viewModel.loadingFormData
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : const Icon(Icons.arrow_drop_down),
            ),
            child: _contentItems.isEmpty
                ? Text(l10n.noItemsConfigured,
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontStyle: FontStyle.italic))
                : Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: _contentItems.map((k) {
                      final label = options[k] ?? k;
                      return Chip(
                        label:
                            Text(label, style: const TextStyle(fontSize: 12)),
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        onDeleted: _isLoading
                            ? null
                            : () => setState(() => _contentItems.remove(k)),
                      );
                    }).toList(),
                  ),
          ),
        ),
      ],
    );
  }

  /// Proto multi-select inline row (shown for geoip and asn).
  Widget _buildProtoSelector() {
    final l10n = AppLocalizations.of(context)!;
    const protoOptions = <String, String>{
      'IPv4': 'IPv4',
      'IPv6': 'IPv6',
    };

    Future<void> openPicker() async {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (_) => PickerSheet(
          title: l10n.protoLabel,
          options: protoOptions,
          initialSelected: _selectedProto,
          isLoading: false,
          searchHint: l10n.searchAliases,
          doneLabel: l10n.done,
          emptyLabel: l10n.noItemsConfigured,
          showSubtitle: false,
          onDone: (result) => setState(() =>
              _selectedProto = result.isNotEmpty ? result : ['IPv4', 'IPv6']),
        ),
      );
    }

    return FormSectionContainer(
      title: l10n.protoLabel,
      children: [
        InkWell(
          onTap: _isLoading ? null : openPicker,
          borderRadius:
              BorderRadius.circular(AppConstants.buttonBorderRadius),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: l10n.protoLabel,
              prefixIcon: const Icon(Icons.filter_list),
              suffixIcon: const Icon(Icons.arrow_drop_down),
              helperText: l10n.protoHint,
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: _selectedProto.map((p) {
                return Chip(
                  label: Text(p, style: const TextStyle(fontSize: 12)),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /// Refresh frequency (days + hours) section.
  Widget _buildRefreshFrequencySection() {
    final l10n = AppLocalizations.of(context)!;
    return FormSectionContainer(
      title: l10n.refreshFrequencyLabel,
      children: [
        Text(
          l10n.refreshFrequencyHint,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _refreshDaysController,
                decoration: InputDecoration(
                  labelText: l10n.refreshDaysHint,
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                keyboardType: TextInputType.number,
                enabled: !_isLoading,
                validator: (v) {
                  if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
                    return l10n.fieldRequired;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _refreshHoursController,
                decoration: InputDecoration(
                  labelText: l10n.refreshHoursHint,
                  prefixIcon: const Icon(Icons.access_time_outlined),
                ),
                keyboardType: TextInputType.number,
                enabled: !_isLoading,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final n = int.tryParse(v);
                    if (n == null || n < 0 || n > 23) {
                      return '0–23';
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Path expression section (urljson only).
  Widget _buildPathExpressionSection() {
    final l10n = AppLocalizations.of(context)!;
    return FormSectionContainer(
      title: l10n.pathExpressionLabel,
      children: [
        TextFormField(
          controller: _pathExpressionController,
          decoration: InputDecoration(
            labelText: l10n.pathExpressionLabel,
            hintText: 'e.g. container.fieldname',
            prefixIcon: const Icon(Icons.code_outlined),
            helperText: l10n.pathExpressionHint,
            helperMaxLines: 3,
          ),
          enabled: !_isLoading,
        ),
      ],
    );
  }

  /// Authorization section (host, url, urltable, urljson).
  Widget _buildAuthorizationSection() {
    final l10n = AppLocalizations.of(context)!;
    final authtypeOptions = <String, String>{
      '':       l10n.none,
      'Basic':  'Basic Auth',
      'Bearer': 'Bearer Token',
      'Header': 'HTTP Header',
    };

    return FormSectionContainer(
      title: l10n.authorizationLabel,
      children: [
        DropdownButtonFormField<String>(
          initialValue: _selectedAuthtype,
          decoration: InputDecoration(
            labelText: l10n.authorizationLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            helperText: l10n.authorizationHint,
            helperMaxLines: 2,
          ),
          isExpanded: true,
          items: authtypeOptions.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
          onChanged: _isLoading
              ? null
              : (v) => setState(() => _selectedAuthtype = v ?? ''),
        ),
        // Username: shown for Basic (credential) and Header (HTTP header name), not Bearer
        if (_selectedAuthtype == 'Basic' || _selectedAuthtype == 'Header') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: _selectedAuthtype == 'Header' ? 'HTTP Header' : 'Username',
              prefixIcon: const Icon(Icons.person_outline),
            ),
            enabled: !_isLoading,
          ),
        ],
        // Password / token: shown for all non-empty authtypes
        if (_selectedAuthtype.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: _selectedAuthtype == 'Basic' ? 'Password' : 'API Token',
              prefixIcon: const Icon(Icons.password_outlined),
            ),
            obscureText: true,
            enabled: !_isLoading,
          ),
        ],
      ],
    );
  }

  /// Interface dropdown (dynipv6host only).
  Widget _buildInterfaceSection() {
    final l10n = AppLocalizations.of(context)!;
    final interfaces = _viewModel.availableInterfaces;

    return FormSectionContainer(
      title: l10n.interface,
      children: [
        DropdownButtonFormField<String>(
          initialValue: interfaces.containsKey(_selectedInterface)
              ? _selectedInterface
              : (interfaces.isNotEmpty ? interfaces.keys.first : null),
          decoration: InputDecoration(
            labelText: l10n.interface,
            prefixIcon: const Icon(Icons.network_check),
            helperText: l10n.interfaceHint,
            helperMaxLines: 2,
          ),
          isExpanded: true,
          items: _viewModel.loadingFormData
              ? [DropdownMenuItem(value: '', child: Text(l10n.loading))]
              : interfaces.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value,
                            overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
          onChanged: _isLoading || _viewModel.loadingFormData
              ? null
              : (v) {
                  if (v != null) {
                    setState(() => _selectedInterface = v);
                  }
                },
        ),
      ],
    );
  }

  /// Expire field (external only).
  Widget _buildExpireSection() {
    final l10n = AppLocalizations.of(context)!;
    return FormSectionContainer(
      title: l10n.expireLabel,
      children: [
        TextFormField(
          controller: _expireController,
          decoration: InputDecoration(
            labelText: l10n.expireLabel,
            prefixIcon: const Icon(Icons.timer_outlined),
            helperText: l10n.expireHint,
            helperMaxLines: 2,
          ),
          keyboardType: TextInputType.number,
          enabled: !_isLoading,
          validator: (v) {
            if (v != null && v.isNotEmpty && int.tryParse(v) == null) {
              return l10n.fieldRequired;
            }
            return null;
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final allow = await _confirmDiscard();
        if (allow && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isEditing ? l10n.editAlias : l10n.createAlias,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              tooltip: l10n.save,
              onPressed: _isLoading ? null : _saveAlias,
            ),
          ],
        ),
        body: LoadingOverlay(
          isLoading: _isLoading,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.standardPadding,
              ),
              children: [
                // ── BASIC SETTINGS ────────────────────────────────────────────
                FormSectionContainer(
                  title: l10n.basicSettingsLabel,
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.enabled),
                      subtitle: Text(l10n.enableThisAlias),
                      value: _enabled,
                      onChanged: _isLoading ? null : (v) => setState(() => _enabled = v),
                    ),
                    const SizedBox(height: AppConstants.standardPadding),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.aliasNameLabel,
                        hintText: l10n.aliasNameHint,
                        prefixIcon: const Icon(Icons.badge_outlined),
                        helperMaxLines: 3,
                      ),
                      enabled: !_isLoading,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]{0,31}$').hasMatch(v)) {
                          return l10n.aliasNameValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppConstants.standardPadding),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedType,
                      decoration: InputDecoration(
                        labelText: l10n.aliasTypeLabel,
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      isExpanded: true,
                      items: _kAliasTypes.entries
                          .map((e) => DropdownMenuItem(
                                value: e.key,
                                child: Text(e.value,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: _isLoading
                          ? null
                          : (v) {
                              if (v != null && v != _selectedType) {
                                setState(() {
                                  _selectedType = v;
                                  // Reset type-specific state on type change
                                  _contentItems = [];
                                  for (final k in _geoipSelections.keys) {
                                    _geoipSelections[k] = [];
                                  }
                                  _selectedProto = ['IPv4', 'IPv6'];
                                  _selectedInterface = '';
                                  _selectedAuthtype = '';
                                });
                              }
                            },
                    ),
                  ],
                ),

                // ── CATEGORIES ────────────────────────────────────────────────
                FormSectionContainer(
                  title: l10n.categoriesLabel,
                  children: [_buildCategoryPickerField()],
                ),

                // ── TYPE-CONDITIONAL SECTIONS ─────────────────────────────────
                if (_showRefreshFrequency) _buildRefreshFrequencySection(),
                _buildContentSection(),
                if (_showPathExpression) _buildPathExpressionSection(),
                if (_showAuthorization) _buildAuthorizationSection(),
                if (_showProtoSelector) _buildProtoSelector(),
                if (_showInterface) _buildInterfaceSection(),
                if (_showExpire) _buildExpireSection(),

                // ── STATISTICS ────────────────────────────────────────────────
                if (_selectedType != 'port')
                  FormSectionContainer(
                    title: l10n.statisticsLabel,
                    children: [
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.statisticsLabel),
                        subtitle: Text(l10n.statisticsHint),
                        value: _statistics,
                        onChanged: _isLoading
                            ? null
                            : (v) => setState(() => _statistics = v),
                      ),
                    ],
                  ),

                // ── DESCRIPTION ───────────────────────────────────────────────
                FormSectionContainer(
                  title: l10n.description,
                  children: [
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: l10n.description,
                        hintText: l10n.optional,
                        prefixIcon: const Icon(Icons.description_outlined),
                      ),
                      maxLines: 2,
                      enabled: !_isLoading,
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.standardPadding * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

