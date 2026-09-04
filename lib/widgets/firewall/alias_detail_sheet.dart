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
import '../../l10n/app_localizations.dart';
import '../../models/firewall_alias.dart';
import '../../services/demo_api_service.dart';
import '../../utils/app_colors.dart';
import '../../utils/snackbar_helper.dart';

/// Draggable bottom sheet showing full alias details.
///
/// Fetches the complete alias data from [getFirewallAlias] on open so
/// that multi-select fields (content, proto, interface) are properly
/// parsed and displayed — rather than relying on the list-endpoint
/// summary data which may be incomplete.
class AliasDetailSheet extends StatefulWidget {
  final FirewallAlias alias;
  final DemoApiService apiService;

  const AliasDetailSheet({
    super.key,
    required this.alias,
    required this.apiService,
  });

  @override
  State<AliasDetailSheet> createState() => _AliasDetailSheetState();
}

class _AliasDetailSheetState extends State<AliasDetailSheet> {
  FirewallAlias? _loaded;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Always fetch the full item — the OPNsense API accepts both UUIDs and
    // system alias names (e.g. __wan_network) as the identifier for getItem.
    // Fall back to the already-parsed list data if the call fails.
    try {
      final full = await widget.apiService.getFirewallAlias(widget.alias.uuid);
      if (mounted) {
        setState(() {
          _loaded = full ?? widget.alias;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _loaded = widget.alias;
          _loading = false;
          _error = 'Could not load full details';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final alias = widget.alias;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: AppColors.opacityDivider),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header row
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                child: Row(
                  children: [
                    Icon(
                      _iconForType(alias.type),
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            alias.name,
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              _TypeChip(label: alias.typeDisplayName),
                              if (alias.isSystemAlias) ...[
                                const SizedBox(width: 6),
                                _TypeChip(
                                  label: l10n.systemAliasReadOnly,
                                  color: theme.colorScheme.tertiary,
                                ),
                              ],
                              if (!alias.isEnabled) ...[
                                const SizedBox(width: 6),
                                _TypeChip(
                                  label: l10n.disabled,
                                  color: theme.colorScheme.error,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(height: 16),

              // Body
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildBody(context, l10n, _loaded!, scrollController),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    FirewallAlias alias,
    ScrollController scrollController,
  ) {
    final contentItems = alias.contentList;
    final runtimeCount = int.tryParse(alias.currentItems) ?? 0;

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      children: [
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _error!,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.error, fontSize: 12),
            ),
          ),

        // ── Basic Settings ───────────────────────────────────────────
        _SectionHeader(title: l10n.basicSettingsLabel, icon: Icons.info_outline),
        _DetailCard(rows: [
          if (alias.description.isNotEmpty)
            _Row(l10n.description, alias.description, icon: Icons.notes),
          _Row(l10n.type, alias.typeDisplayName, icon: Icons.label_outline),
          _Row(
            l10n.enabled,
            alias.isEnabled ? l10n.yes : l10n.no,
            icon: alias.isEnabled ? Icons.check_circle_outline : Icons.cancel_outlined,
            valueColor: alias.isEnabled
                ? Colors.green
                : Theme.of(context).colorScheme.error,
          ),
          if (alias.proto.isNotEmpty)
            _Row(l10n.protoLabel, alias.proto, icon: Icons.filter_list),
          if (alias.interface.isNotEmpty && alias.interface != '')
            _Row(l10n.interface, alias.interface.toUpperCase(),
                icon: Icons.router),
          if (alias.categoryLabels.isNotEmpty)
            _Row(l10n.categoriesLabel, alias.categoryLabels,
                icon: Icons.folder_outlined),
          if (alias.categoryLabels.isEmpty && alias.categories.isNotEmpty)
            _Row(l10n.categoriesLabel, alias.categories,
                icon: Icons.folder_outlined),
        ]),

        const SizedBox(height: 16),

        // ── Content ──────────────────────────────────────────────────
        _SectionHeader(
          title: contentItems.isNotEmpty
              ? l10n.aliasContentEntries(contentItems.length)
              : l10n.content,
          icon: Icons.list_alt,
        ),
        contentItems.isEmpty
            ? Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onLongPress: runtimeCount > 0
                      ? () => _copyValue(context, alias.currentItems)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          runtimeCount > 0
                              ? Icons.info_outline
                              : Icons.inbox_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            runtimeCount > 0
                                ? l10n.aliasRuntimeEntries(alias.currentItems)
                                : l10n.noContent,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Card(
                child: Column(
                  children: [
                    for (int i = 0; i < contentItems.length; i++) ...[
                      InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: i == 0 ? const Radius.circular(12) : Radius.zero,
                          topRight: i == 0 ? const Radius.circular(12) : Radius.zero,
                          bottomLeft: i == contentItems.length - 1 ? const Radius.circular(12) : Radius.zero,
                          bottomRight: i == contentItems.length - 1 ? const Radius.circular(12) : Radius.zero,
                        ),
                        onLongPress: () => _copyValue(context, contentItems[i]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              Icon(Icons.circle,
                                  size: 6,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  contentItems[i],
                                  style: const TextStyle(
                                      fontFamily: 'monospace', fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (i < contentItems.length - 1)
                        const Divider(height: 1, indent: 32),
                    ],
                  ],
                ),
              ),

        // ── URL / path settings ──────────────────────────────────────
        if (alias.updatefreq.isNotEmpty || alias.pathExpression.isNotEmpty) ...[
          const SizedBox(height: 16),
          _SectionHeader(title: l10n.refreshFrequencyLabel, icon: Icons.update),
          _DetailCard(rows: [
            if (alias.updatefreq.isNotEmpty)
              _Row(l10n.refreshFrequencyLabel, alias.updatefreq,
                  icon: Icons.schedule),
            if (alias.pathExpression.isNotEmpty)
              _Row(l10n.pathExpressionLabel, alias.pathExpression,
                  icon: Icons.code),
          ]),
        ],

        // ── Metadata ─────────────────────────────────────────────────
        const SizedBox(height: 16),
        _SectionHeader(title: l10n.aliasMetadata, icon: Icons.analytics_outlined),
        _DetailCard(rows: [
          _Row(l10n.countersLabel, alias.counters, icon: Icons.bar_chart),
          if (!alias.isSystemAlias)
            _Row('UUID', alias.uuid,
                icon: Icons.fingerprint, monospace: true),
        ]),

        const SizedBox(height: 8),
      ],
    );
  }

  IconData _iconForType(String type) {
    switch (type.toLowerCase()) {
      case 'host':        return Icons.computer;
      case 'network':     return Icons.lan;
      case 'port':        return Icons.settings_ethernet;
      case 'url':
      case 'urltable':
      case 'urljson':     return Icons.link;
      case 'geoip':       return Icons.public;
      case 'networkgroup':return Icons.group_work;
      case 'mac':         return Icons.devices;
      case 'asn':         return Icons.numbers;
      case 'dynipv6host': return Icons.dns;
      case 'authgroup':   return Icons.group;
      case 'internal':    return Icons.home;
      case 'external':    return Icons.cloud;
      default:            return Icons.label;
    }
  }
}

// ── Shared copy helper ───────────────────────────────────────────────────────

void _copyValue(BuildContext context, String value) {
  Clipboard.setData(ClipboardData(text: value));
  SnackBarHelper.showInfo(
    context,
    AppLocalizations.of(context)!.copiedToClipboard,
    duration: const Duration(seconds: 1),
  );
}

// ── Private helpers ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A label + value row used inside [_DetailCard].
class _Row {
  final String label;
  final String value;
  final IconData? icon;
  final Color? valueColor;
  final bool monospace;
  const _Row(this.label, this.value,
      {this.icon, this.valueColor, this.monospace = false});
}

class _DetailCard extends StatelessWidget {
  final List<_Row> rows;
  const _DetailCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visible = rows.where((r) => r.value.isNotEmpty).toList();
    if (visible.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            for (int i = 0; i < visible.length; i++) ...[
              InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: i == 0 ? const Radius.circular(12) : Radius.zero,
                  topRight: i == 0 ? const Radius.circular(12) : Radius.zero,
                  bottomLeft: i == visible.length - 1 ? const Radius.circular(12) : Radius.zero,
                  bottomRight: i == visible.length - 1 ? const Radius.circular(12) : Radius.zero,
                ),
                onLongPress: () => _copyValue(context, visible[i].value),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (visible[i].icon != null) ...[
                        Icon(visible[i].icon,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 8),
                      ],
                      SizedBox(
                        width: 110,
                        child: Text(
                          visible[i].label,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          visible[i].value,
                          style: TextStyle(
                            color: visible[i].valueColor ??
                                theme.colorScheme.onSurface,
                            fontWeight: visible[i].valueColor != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                            fontFamily: visible[i].monospace ? 'monospace' : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (i < visible.length - 1)
                const Divider(height: 1, indent: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final Color? color;
  const _TypeChip({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c),
      ),
    );
  }
}
