import 'package:hive/hive.dart';

part 'category.g.dart';  // Gerado automaticamente pelo Hive

@HiveType(typeId: 1)  // Identificador do tipo para o Hive
class Category {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int iconCodePoint;

  @HiveField(3)
  final int colorValue;

  @HiveField(4)
  final String? imageUrl;

  Category({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    this.imageUrl,
  });

  // Método para criar um Category a partir de um Map (útil para DB ou JSON)
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      iconCodePoint: map['iconCodePoint'],
      colorValue: map['colorValue'],
      imageUrl: map['imageUrl'],
    );
  }

  // Método para converter o Category em um Map (útil para salvar em DB ou JSON)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': iconCodePoint,
      'colorValue': colorValue,
      'imageUrl': imageUrl,
    };
  }
}
