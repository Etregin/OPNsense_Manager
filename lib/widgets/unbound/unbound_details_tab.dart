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
import '../../models/unbound_query_item.dart';
import '../../utils/app_colors.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../viewmodels/unbound_dns_view_model.dart';

enum UnboundQueryColumn {
  id,
  status,
  time,
  client,
  family,
  type,
  domain,
  action,
  source,
  rcode,
  resolveTime,
  ttl,
  blocklist,
  policy,
}

class UnboundDetailsTab extends StatefulWidget {
  final UnboundDnsViewModel viewModel;

  const UnboundDetailsTab({
    super.key,
    required this.viewModel,
  });

  @override
  State<UnboundDetailsTab> createState() => _UnboundDetailsTabState();
}

class _UnboundDetailsTabState extends State<UnboundDetailsTab> {
  final TextEditingController _searchController = TextEditingController();
  final Set<UnboundQueryColumn> _visibleColumns = {
    UnboundQueryColumn.time,
    UnboundQueryColumn.client,
    UnboundQueryColumn.type,
    UnboundQueryColumn.domain,
    UnboundQueryColumn.action,
    UnboundQueryColumn.source,
    UnboundQueryColumn.rcode,
  };

  UnboundDnsViewModel get _vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _searchController.text = _vm.queriesSearchPhrase;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getColumnTitle(AppLocalizations l10n, UnboundQueryColumn col) {
    switch (col) {
      case UnboundQueryColumn.id:
        return l10n.id;
      case UnboundQueryColumn.status:
        return l10n.status;
      case UnboundQueryColumn.time:
        return l10n.time;
      case UnboundQueryColumn.client:
        return l10n.client;
      case UnboundQueryColumn.family:
        return l10n.unboundFamily;
      case UnboundQueryColumn.type:
        return l10n.unboundQueryType;
      case UnboundQueryColumn.domain:
        return l10n.domain;
      case UnboundQueryColumn.action:
        return l10n.action;
      case UnboundQueryColumn.source:
        return l10n.source;
      case UnboundQueryColumn.rcode:
        return l10n.unboundReturnCode;
      case UnboundQueryColumn.resolveTime:
        return l10n.unboundResolveTime;
      case UnboundQueryColumn.ttl:
        return l10n.unboundTtl;
      case UnboundQueryColumn.blocklist:
        return l10n.unboundBlocklist;
      case UnboundQueryColumn.policy:
        return l10n.unboundPolicy;
    }
  }

  Widget _buildCell(
    BuildContext context,
    UnboundQueryItem item,
    UnboundQueryColumn col,
  ) {
    final theme = Theme.of(context);
    switch (col) {
      case UnboundQueryColumn.id:
        return Text(
          item.uuid != null && item.uuid!.length > 8
              ? item.uuid!.substring(0, 8)
              : (item.uuid ?? '-'),
          style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
        );
      case UnboundQueryColumn.status:
        final statusVal = item.status?.toString() ?? '-';
        return Text(statusVal, style: theme.textTheme.bodySmall);
      case UnboundQueryColumn.time:
        final formattedTime = item.time != null
            ? Formatters.formatDateTime(
                DateTime.fromMillisecondsSinceEpoch(item.time! * 1000),
              )
            : '-';
        return Text(
          formattedTime,
          style: theme.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        );
      case UnboundQueryColumn.client:
        return Text(
          item.client ?? '-',
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        );
      case UnboundQueryColumn.family:
        return Text(item.family ?? '-', style: theme.textTheme.bodySmall);
      case UnboundQueryColumn.type:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            item.type ?? '-',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case UnboundQueryColumn.domain:
        return Text(
          item.domain ?? '-',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
          ),
          overflow: TextOverflow.ellipsis,
        );
      case UnboundQueryColumn.action:
        final actionText = item.action ?? '-';
        final isPass = actionText.toLowerCase().contains('pass');
        final isBlock = actionText.toLowerCase().contains('block');
        Color chipColor = theme.colorScheme.surfaceContainerHighest;
        Color textColor = theme.colorScheme.onSurfaceVariant;
        if (isPass) {
          chipColor = AppColors.success.withValues(alpha: AppColors.opacityBare);
          textColor = AppColors.success;
        } else if (isBlock) {
          chipColor = AppColors.error.withValues(alpha: AppColors.opacityBare);
          textColor = AppColors.error;
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: chipColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            actionText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case UnboundQueryColumn.source:
        return Text(item.source ?? '-', style: theme.textTheme.bodySmall);
      case UnboundQueryColumn.rcode:
        return Text(item.rcode ?? '-', style: theme.textTheme.bodySmall);
      case UnboundQueryColumn.resolveTime:
        return Text(
          item.resolveTimeMs != null ? '${item.resolveTimeMs} ms' : '-',
          style: theme.textTheme.bodySmall,
        );
      case UnboundQueryColumn.ttl:
        return Text(
          item.ttl?.toString() ?? '-',
          style: theme.textTheme.bodySmall,
        );
      case UnboundQueryColumn.blocklist:
        return Text(
          item.blocklist?.isNotEmpty == true ? item.blocklist! : '-',
          style: theme.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        );
      case UnboundQueryColumn.policy:
        return Text(
          item.policy?.isNotEmpty == true ? item.policy! : '-',
          style: theme.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        );
    }
  }

  void _showColumnVisibilityDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(l10n.unboundVisibleColumns),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: UnboundQueryColumn.values.map((col) {
                    final isChecked = _visibleColumns.contains(col);
                    return CheckboxListTile(
                      title: Text(_getColumnTitle(l10n, col)),
                      value: isChecked,
                      onChanged: (bool? val) {
                        setDialogState(() {
                          if (val == true) {
                            _visibleColumns.add(col);
                          } else {
                            if (_visibleColumns.length > 1) {
                              _visibleColumns.remove(col);
                            }
                          }
                        });
                        setState(() {});
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(l10n.close),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final rowsPerPageOptions = [50, 100, 200, 500, 1000, -1];
    final totalQueries = _vm.queriesTotal;
    final currentPage = _vm.queriesCurrentPage;
    final rowCount = _vm.queriesRowCount;
    final totalPages = rowCount == -1
        ? 1
        : ((totalQueries + rowCount - 1) / (rowCount > 0 ? rowCount : 1)).floor().clamp(1, 999999);

    final orderedVisibleCols = UnboundQueryColumn.values
        .where((c) => _visibleColumns.contains(c))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.standardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter & Search Toolbar
          Card(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.standardPadding),
              child: Column(
                children: [
                  if (_vm.activeFilterLabel != null) ...[
                    Row(
                      children: [
                        InputChip(
                          avatar: const Icon(Icons.filter_alt, size: 16),
                          label: Text(
                            _vm.activeFilterLabel!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onDeleted: () {
                            _vm.clearQueriesClientTimeFilter();
                          },
                          deleteIcon: const Icon(Icons.close, size: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.compactPadding),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: l10n.searchQueries,
                            prefixIcon: const Icon(Icons.search, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 18),
                                    onPressed: () {
                                      _searchController.clear();
                                      _vm.setQueriesSearchPhrase('');
                                    },
                                  )
                                : null,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onSubmitted: (val) {
                            _vm.setQueriesSearchPhrase(val.trim());
                          },
                        ),
                      ),
                      const SizedBox(width: AppConstants.compactPadding),
                      IconButton.filledTonal(
                        icon: const Icon(Icons.view_column, size: 20),
                        tooltip: l10n.unboundVisibleColumns,
                        onPressed: () => _showColumnVisibilityDialog(context, l10n),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.compactPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Rows per page
                      Row(
                        children: [
                          Text(
                            l10n.rowsPerPageLabel,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 4),
                          DropdownButton<int>(
                            value: _vm.queriesRowCount,
                            isDense: true,
                            underline: const SizedBox.shrink(),
                            items: rowsPerPageOptions.map((opt) {
                              return DropdownMenuItem<int>(
                                value: opt,
                                child: Text(
                                  opt == -1 ? l10n.all : opt.toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                _vm.setQueriesRowCount(val);
                              }
                            },
                          ),
                        ],
                      ),
                      // Total count indicator
                      Text(
                        '$totalQueries ${l10n.unboundQueries}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.standardPadding),

          // Queries Table
          Card(
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.compactPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_vm.isQueriesLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_vm.queries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          l10n.noDataAvailable,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 40,
                        dataRowMinHeight: 36,
                        dataRowMaxHeight: 44,
                        columnSpacing: 18,
                        columns: orderedVisibleCols.map((col) {
                          return DataColumn(
                            label: Text(
                              _getColumnTitle(l10n, col),
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                        rows: _vm.queries.map((item) {
                          return DataRow(
                            cells: orderedVisibleCols.map((col) {
                              return DataCell(_buildCell(context, item, col));
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),

                  // Pagination controls
                  if (totalPages > 1 && !_vm.isQueriesLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.compactPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: currentPage > 1
                                ? () => _vm.setQueriesPage(currentPage - 1)
                                : null,
                          ),
                          Text(
                            '$currentPage / $totalPages',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: currentPage < totalPages
                                ? () => _vm.setQueriesPage(currentPage + 1)
                                : null,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
