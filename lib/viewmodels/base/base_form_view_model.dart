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
import '../../services/base/api_exception.dart';

/// Base ViewModel for form screens with common state management
abstract class BaseFormViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  ApiException? _apiError;
  bool _hasUnsavedChanges = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// The last [ApiException] caught during [executeWithLoading], or [null] if
  /// the last error was not an API error (or there was no error). Cleared on
  /// the next [executeWithLoading] call.
  ApiException? get apiError => _apiError;

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
    _apiError = null;
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

  /// Execute an action with loading state management.
  ///
  /// On success returns the result. On failure calls [setError] with the
  /// human-readable message. If the thrown exception is an [ApiException] it
  /// is also stored in [apiError] so callers can inspect [ApiException.errorType]
  /// for structured error handling.
  Future<T?> executeWithLoading<T>(Future<T> Function() action) async {
    setLoading(true);
    clearError();
    try {
      final result = await action();
      setLoading(false);
      return result;
    } on ApiException catch (e) {
      setLoading(false);
      _apiError = e;
      setError(e.message);
      return null;
    } catch (e) {
      setLoading(false);
      setError(e.toString());
      return null;
    }
  }
}


