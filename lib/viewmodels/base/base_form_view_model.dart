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

import 'package:flutter/foundation.dart';

/// Base ViewModel for form screens with common state management
abstract class BaseFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasUnsavedChanges = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasUnsavedChanges => _hasUnsavedChanges;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void markAsChanged() {
    _hasUnsavedChanges = true;
    notifyListeners();
  }

  void markAsSaved() {
    _hasUnsavedChanges = false;
    notifyListeners();
  }

  /// Execute an action with loading state management
  Future<T?> executeWithLoading<T>(Future<T> Function() action) async {
    debugPrint('BaseFormViewModel: executeWithLoading START');
    setLoading(true);
    clearError();
    try {
      debugPrint('BaseFormViewModel: Executing action...');
      final result = await action();
      debugPrint('BaseFormViewModel: Action completed successfully, result type: ${result.runtimeType}');
      setLoading(false);
      return result;
    } catch (e, stackTrace) {
      debugPrint('BaseFormViewModel: Action FAILED with exception');
      debugPrint('  - Exception: $e');
      debugPrint('  - Exception type: ${e.runtimeType}');
      debugPrint('  - Stack trace: $stackTrace');
      setLoading(false);
      setError(e.toString());
      debugPrint('BaseFormViewModel: Error message set to: ${e.toString()}');
      return null;
    }
  }
}


