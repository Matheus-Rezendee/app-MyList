import 'package:hive/hive.dart';

part 'item.g.dart'; // <- este nome deve ser igual ao do arquivo!

// item.dart
@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  bool isDone; // Torna 'isDone' mutável

  @HiveField(5)
  final String categoryId;

  @HiveField(6)
  final String userId;

  @HiveField(7)
  final DateTime createdAt;

  @HiveField(8)
  final DateTime? updatedAt;

  Item({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.isDone,
    required this.categoryId,
    required this.userId,
    required this.createdAt,
    this.updatedAt,
  });

  // Método para alternar o valor de isDone
  void toggleIsDone() {
    isDone = !isDone;
  }
}
