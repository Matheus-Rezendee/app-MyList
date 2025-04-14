import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  Future<void> loadData() async {
    final itemBox = await Hive.openBox<Item>('items');
    final categoryBox = await Hive.openBox<Category>('categories');

    _items.clear();
    _categories.clear();

    _items.addAll(itemBox.values);
    _categories.addAll(categoryBox.values);

    notifyListeners();
  }

  // ----------------- Categorias ------------------
  void addCategory(Category category) async {
    _categories.add(category);
    final box = await Hive.openBox<Category>('categories');
    await box.put(category.id, category);
    notifyListeners();
  }

  void removeCategory(Category category) async {
    _categories.removeWhere((cat) => cat.id == category.id);
    final categoryBox = await Hive.openBox<Category>('categories');
    final itemBox = await Hive.openBox<Item>('items');

    await categoryBox.delete(category.id);
    _items.removeWhere((item) => item.categoryId == category.id);
    for (var key in itemBox.keys) {
      final item = itemBox.get(key);
      if (item != null && item.categoryId == category.id) {
        await itemBox.delete(key);
      }
    }

    notifyListeners();
  }

  // ----------------- Itens ------------------
  void addItem(Item item) async {
    _items.add(item);
    final box = await Hive.openBox<Item>('items');
    await box.put(item.id, item);
    notifyListeners();
  }

  void removeItem(Item item) async {
    _items.remove(item);
    final box = await Hive.openBox<Item>('items');
    await box.delete(item.id);
    notifyListeners();
  }

  void toggleItemStatus(Item item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final updatedItem = Item(
        id: item.id,
        title: item.title,
        quantity: item.quantity,
        price: item.price,
        isDone: !item.isDone,
        categoryId: item.categoryId,
        userId: item.userId,
        createdAt: item.createdAt,
        updatedAt: DateTime.now(), // Atualiza a data de modificação
      );

      _items[index] = updatedItem;
      final box = await Hive.openBox<Item>('items');
      await box.put(item.id, updatedItem);
      notifyListeners();
    }
  }

  void updateItem(Item updatedItem) async {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      final box = await Hive.openBox<Item>('items');
      await box.put(updatedItem.id, updatedItem);
      notifyListeners();
    }
  }

  List<Item> getItemsByCategory(Category category) {
    return _items.where((item) => item.categoryId == category.id).toList();
  }
}
