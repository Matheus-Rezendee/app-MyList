import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/item.dart';

/// Gerencia o estado das listas e itens
class ListProvider extends ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => _categories;

  void addCategory(Category newCategory) {
    _categories.add(newCategory);
    notifyListeners();
  }

  void addItem(String categoryId, Item item) {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    category.items.add(item);
    notifyListeners();
  }

  void toggleItemStatus(String categoryId, String itemId) {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    final item = category.items.firstWhere((i) => i.id == itemId);
    item.isCompleted = !item.isCompleted;
    notifyListeners();
  }

  void removeItem(String categoryId, String itemId) {
    final category = _categories.firstWhere((c) => c.id == categoryId);
    category.items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }
}