import 'package:flutter/material.dart';
import 'item.dart';

/// Modelo para representar uma categoria de compras
class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final List<Item> items;

  Category({
    required this.name,
    required this.icon,
    required this.color,
    List<Item>? items,
  })  : id = DateTime.now().toIso8601String(),
        items = items ?? [];
}