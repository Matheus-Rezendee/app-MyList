import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/list_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/category_creation_dialog.dart';
import '../screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDataOnStart();
  }

  Future<void> _loadDataOnStart() async {
    final provider = Provider.of<ListProvider>(context, listen: false);
    await provider.loadData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = Provider.of<ListProvider>(context);
    final categories = listProvider.categories;

    return Scaffold(
      endDrawer: _buildDrawer(context),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _buildQuote(),
                            const SizedBox(height: 24),
                            _buildSummaryCards(listProvider),
                            const SizedBox(height: 24),
                            Expanded(
                              child: categories.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'Nenhuma lista criada ainda.\nToque no botão abaixo para começar.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      itemCount: categories.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 1.1,
                                      ),
                                      itemBuilder: (context, index) {
                                        final category = categories[index];
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CategoryScreen(
                                                  category: category,
                                                ),
                                              ),
                                            );
                                          },
                                          child: CategoryCard(
                                            category: category,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: 16,
            child: Builder(
              builder: (context) => InkWell(
                borderRadius: BorderRadius.circular(32),
                onTap: () => Scaffold.of(context).openEndDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.menu, color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const CategoryCreationDialog(),
                );
              },
              backgroundColor: const Color(0xFF6C5CE7),
              icon: const Icon(Icons.add),
              label: const Text(
                'Nova Lista',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF341f97)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            'Olá, Matheus 👋',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(2.0, 2.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vamos deixar suas compras organizadas hoje?',
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuote() {
    return const Text(
      '“Organização é a chave para economizar tempo e dinheiro.”',
      style: TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildSummaryCards(ListProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildStatCard(
            title: 'Total de Listas',
            value: '${provider.totalLists}',
            icon: Icons.list_alt_rounded,
            color: const Color(0xFF6C5CE7),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: 'Total de Itens',
            value: '${provider.totalItems}',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF00CEC9),
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            title: 'Total R\$',
            value: provider.totalValue.toStringAsFixed(2),
            icon: Icons.attach_money_rounded,
            color: const Color(0xFFFFC107),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: Text('Configurações'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
