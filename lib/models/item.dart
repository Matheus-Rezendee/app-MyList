/// Modelo para representar um item dentro de uma categoria
class Item {
  final String id;
  final String name;
  final double price;
  final int quantity;
  bool isCompleted;

  Item({
    required this.name,
    required this.price,
    required this.quantity,
    this.isCompleted = false,
  }) : id = DateTime.now().toIso8601String();
}