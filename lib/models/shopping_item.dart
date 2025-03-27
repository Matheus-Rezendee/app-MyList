class ShoppingItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  bool isPurchased;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.isPurchased = false,
  });
}