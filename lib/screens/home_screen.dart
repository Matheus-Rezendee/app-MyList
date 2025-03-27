import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/list_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/add_category_card.dart';
import '../widgets/category_creation_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<ListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Listas'),
        backgroundColor: const Color(0xFF6C5CE7), // Cor do AppBar
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<AuthProvider>().logout(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF6C5CE7), // Cor do Drawer Header
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.category_rounded, color: Colors.black54),
              title: const Text('Minhas Categorias'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.black54),
              title: const Text('Configurações'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de boas-vindas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo ao MyList!',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6C5CE7),
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crie, organize e gerencie suas listas de maneira simples e eficiente.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Seção de Minhas Listas Criadas
            Text(
              'Minhas Listas Criadas',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: listProvider.categories.isEmpty
                  ? _buildEmptyState(context)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.9,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: listProvider.categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == listProvider.categories.length) {
                          return AddCategoryCard(onTap: () => _showCreateListDialog(context));
                        }
                        return CategoryCard(category: listProvider.categories[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Tela de "Nenhuma Lista Criada"
  Widget _buildEmptyState(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.checklist_rounded,
          size: 60,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 10),
        Text(
          'Ainda não há listas criadas.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        // Card de criação de nova categoria
        AddCategoryCard(onTap: () => _showCreateListDialog(context)),
      ],
    );
  }

  // Exibe a tela de criação de lista
  void _showCreateListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CategoryCreationDialog(),
    );
  }
}
