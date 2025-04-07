import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../models/category.dart';
import '../providers/list_provider.dart';
import '../widgets/add_item_dialog.dart';
import '../services/unsplash_service.dart';

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  void _addItem(BuildContext context) async {
    final newItem = await showDialog<Item>(
      context: context,
      builder: (_) => AddItemDialog(categoryId: category.id),
    );

    if (newItem != null) {
      Provider.of<ListProvider>(context, listen: false).addItem(newItem);
    }
  }

  void _editItem(BuildContext context, Item item) async {
    final updatedItem = await showDialog<Item>(
      context: context,
      builder: (_) => AddItemDialog(
        categoryId: category.id,
        existingItem: item,
      ),
    );

    if (updatedItem != null) {
      Provider.of<ListProvider>(context, listen: false).updateItem(updatedItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final items = listProvider.getItemsByCategory(category);
    final pendingItems = items.where((item) => !item.isDone).toList();
    final completedItems = items.where((item) => item.isDone).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
      body: items.isEmpty
          ? const Center(child: Text('Nenhum item adicionado ainda.'))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pendingItems.isNotEmpty)
                    _buildSectionTitle('Pendentes'),
                  ...pendingItems.map((item) => _buildItemTile(context, item, listProvider)),
                  if (completedItems.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionTitle('Concluídos'),
                    ...completedItems.map((item) => _buildItemTile(context, item, listProvider)),
                  ],
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        backgroundColor: const Color(0xFF6C5CE7),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, Item item, ListProvider provider) {
    return FutureBuilder<String?>(
      future: UnsplashService.fetchImageUrl(item.title),
      builder: (context, snapshot) {
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: snapshot.hasData
                  ? NetworkImage(snapshot.data!)
                  : const AssetImage('assets/images/placeholder.png')
                      as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            title: Text(
              item.title,
              style: TextStyle(
                decoration: item.isDone ? TextDecoration.lineThrough : null,
                color: item.isDone ? Colors.grey : null,
              ),
            ),
            subtitle: Text(
              'Qtd: ${item.quantity} • Preço: R\$ ${item.price?.toStringAsFixed(2) ?? "-"}',
            ),
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: Icon(
                    item.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: item.isDone ? Colors.green : Colors.grey,
                  ),
                  onPressed: () {
                    provider.toggleItemStatus(item);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: () => _editItem(context, item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => provider.removeItem(item),
                ),
              ],
            ),
            onTap: () => _editItem(context, item),
          ),
        );
      },
    );
  }
}
