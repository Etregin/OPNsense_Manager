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

/// Decorator pattern for handling demo mode API calls
/// Reduces code duplication by centralizing the demo mode check logic
class DemoApiDecorator {
  /// Execute a function with demo mode handling
  /// 
  /// If demo mode is enabled, executes [demoAction] after a simulated delay.
  /// Otherwise, executes [realAction].
  /// 
  /// [isDemoMode] - Whether demo mode is active
  /// [demoAction] - Function to execute in demo mode
  /// [realAction] - Function to execute in real mode
  /// [delayMs] - Simulated network delay in milliseconds (default: 300)
  static Future<T> execute<T>({
    required bool isDemoMode,
    required Future<T> Function() demoAction,
    required Future<T> Function() realAction,
    int delayMs = 300,
  }) async {
    if (isDemoMode) {
      await Future.delayed(Duration(milliseconds: delayMs));
      return demoAction();
    }
    return realAction();
  }

  /// Execute a synchronous function with demo mode handling
  /// 
  /// For operations that don't require async execution
  static T executeSync<T>({
    required bool isDemoMode,
    required T Function() demoAction,
    required T Function() realAction,
  }) {
    if (isDemoMode) {
      return demoAction();
    }
    return realAction();
  }
}


