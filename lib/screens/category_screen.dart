import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/list_provider.dart';
import '../models/category.dart';
import '../models/item.dart';
import '../widgets/add_item_dialog.dart';

/// Tela que exibe os itens de uma categoria específica
class CategoryScreen extends StatelessWidget {
  final Category category;
  const CategoryScreen({required this.category, super.key});
  
  get context => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: category.items.length,
        itemBuilder: (context, index) => _buildItemCard(category.items[index]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: category.color,
        onPressed: () => _showAddItemDialog(context),
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  /// Constrói o card de um item com opções de interação
  Widget _buildItemCard(Item item) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: Colors.white, size: 40),
      ),
      onDismissed: (_) => context.read<ListProvider>().removeItem(category.id, item.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          leading: Checkbox(
            value: item.isCompleted,
            onChanged: (_) => context.read<ListProvider>().toggleItemStatus(category.id, item.id),
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (states) => item.isCompleted ? category.color : Colors.transparent,
            ),
          ),
          title: Text(
            item.name,
            style: TextStyle(
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            'Quantidade: ${item.quantity} | Total: R\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }

  /// Exibe o diálogo para adicionar novo item
  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddItemDialog(),
    ).then((newItem) {
      if (newItem != null && newItem is Item) {
        context.read<ListProvider>().addItem(category.id, newItem);
      }
    });
  }
}