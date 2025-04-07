class Item {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final bool isDone;
  final String categoryId;

  Item({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.isDone,
    required this.categoryId,
  });
}
