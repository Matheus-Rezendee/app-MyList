import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/category.dart';

class ListProvider with ChangeNotifier {
  final List<Item> _items = [];
  final List<Category> _categories = [];

  List<Item> get items => _items;
  List<Category> get categories => _categories;

  int get totalLists => _categories.length;
  int get totalItems => _items.length;

  double get totalValue {
    return _items.fold(0.0, (sum, item) {
      final itemTotal = (item.price ?? 0.0) * item.quantity;
      return sum + itemTotal;
    });
  }

  // ----------------- Categorias ------------------
  void addCategory(Category category) {
    _categories.add(category);
    notifyListeners();
  }

  void removeCategory(Category category) {
    _categories.removeWhere((cat) => cat.id == category.id);
    removeItemsFromCategory(category);
    notifyListeners();
  }

  void removeCategoryById(String categoryId) {
    _categories.removeWhere((cat) => cat.id == categoryId);
    _items.removeWhere((item) => item.categoryId == categoryId);
    notifyListeners();
  }

  // ----------------- Itens ------------------
  void addItem(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }

  void removeItemsFromCategory(Category category) {
    _items.removeWhere((item) => item.categoryId == category.id);
    notifyListeners();
  }

  List<Item> getItemsByCategory(Category category) {
    return _items.where((item) => item.categoryId == category.id).toList();
  }

  void toggleItemStatus(Item item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = Item(
        id: _items[index].id,
        title: _items[index].title,
        quantity: _items[index].quantity,
        price: _items[index].price,
        isDone: !_items[index].isDone,
        categoryId: _items[index].categoryId,
      );
      notifyListeners();
    }
  }

  // ----------------- Método de Atualização de Itens ------------------
  void updateItem(Item updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();  // Notifica os listeners que a lista foi alterada
    }
  }
}
