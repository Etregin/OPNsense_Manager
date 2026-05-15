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

/// Base ViewModel for list screens with common state management and filtering
abstract class BaseListViewModel<T> extends ChangeNotifier {
  List<T> _items = [];
  List<T> _filteredItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<T> get items => _filteredItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get hasItems => _filteredItems.isNotEmpty;

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

  void setItems(List<T> items) {
    _items = items;
    _applyFilter();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else {
      _filteredItems = _items.where((item) => matchesFilter(item, _searchQuery)).toList();
    }
    notifyListeners();
  }

  /// Override this method to define how items are filtered
  bool matchesFilter(T item, String query);

  /// Load items from the data source
  Future<void> loadItems() async {
    setLoading(true);
    clearError();
    try {
      final items = await fetchItems();
      setItems(items);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Override this method to fetch items from the data source
  Future<List<T>> fetchItems();

  /// Refresh the list
  Future<void> refresh() => loadItems();
}

// Made with Bob
