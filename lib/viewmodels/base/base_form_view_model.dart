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
    setLoading(true);
    clearError();
    try {
      final result = await action();
      setLoading(false);
      return result;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return null;
    }
  }
}

// Made with Bob
