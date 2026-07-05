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
import '../utils/constants.dart';

/// Reusable card widget for displaying statistics
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.standardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (iconColor ?? Theme.of(context).primaryColor)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                  const Spacer(),
                  ?trailing,
                ],
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return card;
  }
}

/// Progress stat card with a progress indicator
class ProgressStatCard extends StatelessWidget {
  final String title;
  final String value;
  final double progress; // 0.0 to 1.0
  final IconData icon;
  final Color? progressColor;
  final String? subtitle;

  const ProgressStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.progress,
    required this.icon,
    this.progressColor,
    this.subtitle,
  });

  Color _getProgressColor(BuildContext context) {
    if (progressColor != null) return progressColor!;
    
    if (progress >= 0.9) {
      return const Color(AppConstants.errorColorValue);
    } else if (progress >= 0.7) {
      return const Color(AppConstants.warningColorValue);
    } else {
      return const Color(AppConstants.successColorValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getProgressColor(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: AppColors.surfaceLight,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Stacked progress stat card with two progress segments (for memory with ARC)
class StackedProgressStatCard extends StatelessWidget {
  final String title;
  final String value;
  final double primaryProgress; // 0.0 to 1.0 (actual used memory)
  final double secondaryProgress; // 0.0 to 1.0 (ARC memory)
  final IconData icon;
  final Color? primaryColor;
  final Color? secondaryColor;
  final String? subtitle;
  
  // New parameters for labeled sections
  final String? primaryLabel;
  final String? secondaryLabel;
  final String? primaryValue;
  final String? secondaryValue;

  const StackedProgressStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.primaryProgress,
    required this.secondaryProgress,
    required this.icon,
    this.primaryColor,
    this.secondaryColor,
    this.subtitle,
    this.primaryLabel,
    this.secondaryLabel,
    this.primaryValue,
    this.secondaryValue,
  });

  Color _getPrimaryColor(BuildContext context) {
    if (primaryColor != null) return primaryColor!;
    
    // Color based on primary progress only (actual memory usage)
    if (primaryProgress >= 0.9) {
      return const Color(AppConstants.errorColorValue);
    } else if (primaryProgress >= 0.7) {
      return const Color(AppConstants.warningColorValue);
    } else {
      return const Color(AppConstants.successColorValue);
    }
  }

  Color _getSecondaryColor(BuildContext context) {
    if (secondaryColor != null) return secondaryColor!;
    
    // Use a lighter shade of the primary color for ARC
    final primary = _getPrimaryColor(context);
    return primary.withValues(alpha: 0.4);
  }

  @override
  Widget build(BuildContext context) {
    final primary = _getPrimaryColor(context);
    final secondary = _getSecondaryColor(context);
    final totalProgress = (primaryProgress + secondaryProgress).clamp(0.0, 1.0);
    final showLabels = primaryLabel != null || secondaryLabel != null;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.standardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: primary,
                    size: 28,
                  ),
                ),
                const Spacer(),
                Text(
                  '${(primaryProgress * 100).toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            // Stacked progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                height: 8,
                child: Stack(
                  children: [
                    // Background
                    Container(
                      width: double.infinity,
                      color: AppColors.surfaceLight,
                    ),
                    // Total progress (primary + secondary)
                    FractionallySizedBox(
                      widthFactor: totalProgress,
                      child: Container(
                        color: secondary,
                      ),
                    ),
                    // Primary progress (actual used)
                    FractionallySizedBox(
                      widthFactor: primaryProgress.clamp(0.0, 1.0),
                      child: Container(
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section labels and values
            if (showLabels) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  // Primary section
                  if (primaryLabel != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: primary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  primaryLabel!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (primaryValue != null) ...[
                            const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                primaryValue!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  // Spacing between sections
                  if (primaryLabel != null && secondaryLabel != null)
                    const SizedBox(width: 16),
                  // Secondary section
                  if (secondaryLabel != null)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  secondaryLabel!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (secondaryValue != null) ...[
                            const SizedBox(height: 2),
                            Padding(
                              padding: const EdgeInsets.only(left: 18),
                              child: Text(
                                secondaryValue!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              ),
            ],
            if (subtitle != null && !showLabels) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Quick action card for navigation
class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(12), // Reduced from 16
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              Container(
                padding: const EdgeInsets.all(12), // Reduced from 16
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32, // Reduced from AppConstants.featureIconSize (48)
                ),
              ),
              const SizedBox(height: 8), // Reduced from 12
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 1, // Added to prevent overflow
                overflow: TextOverflow.ellipsis, // Added
                style: Theme.of(context).textTheme.titleSmall?.copyWith( // Changed from titleMedium
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 2), // Reduced from 4
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1, // Added to prevent overflow
                overflow: TextOverflow.ellipsis, // Added
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

