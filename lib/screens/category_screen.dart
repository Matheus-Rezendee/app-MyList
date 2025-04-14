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

    final hasItems = items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
      body: hasItems
          ? ListView(
              children: [
                _buildItemsSection(context, pendingItems, 'Pendentes', false),
                const SizedBox(height: 16),
                _buildItemsSection(context, completedItems, 'Concluídos', true),
              ],
            )
          : _buildEmptyState(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        child: const Icon(Icons.add),
        backgroundColor: const Color(0xFF6C5CE7),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Nenhum item aqui ainda!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Toque no botão + para adicionar um item à lista.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsSection(
    BuildContext context,
    List<Item> items,
    String title,
    bool isCompleted,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6C5CE7),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: items.map((item) {
              return FutureBuilder<String?>(
                future: UnsplashService.fetchImageUrl(query: item.title),
                builder: (context, snapshot) {
                  final image = snapshot.data;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: image != null
                            ? Image.network(image, width: 50, height: 50, fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 40),
                      ),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Qtd: ${item.quantity}  •  R\$ ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: Icon(isCompleted ? Icons.undo : Icons.check),
                        color: isCompleted ? Colors.grey : Colors.green,
                        onPressed: () {
                          item.toggleIsDone();
                          Provider.of<ListProvider>(context, listen: false).updateItem(item);
                        },
                      ),
                      onTap: () => _editItem(context, item),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
