import 'package:flutter/material.dart';
import '../models/category.dart';
import '../providers/list_provider.dart';
import 'package:provider/provider.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recuperando o ícone com base no código armazenado
    final IconData selectedIcon = IconData(
      category.iconCodePoint,
      fontFamily: 'MaterialIcons',
    );

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Conteúdo principal do card
          Column(
            children: [
              // Imagem ou placeholder fixo
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    color: Color(category.colorValue), // Usando a cor escolhida
                    child: Icon(
                      selectedIcon,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          // Ícone de excluir no canto superior direito
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.grey, // Cinza claro para dar sutileza
                size: 24,
              ),
              onPressed: () async {
                // Excluir categoria com confirmação
                bool confirm = await _showConfirmationSnackbar(context);

                if (confirm) {
                  // Exclui a categoria se o usuário confirmar
                  context.read<ListProvider>().removeCategory(category);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para exibir um Snackbar com opção de desfazer
  Future<bool> _showConfirmationSnackbar(BuildContext context) async {
    final snackBar = SnackBar(
      content: const Text('Categoria excluída!'),
      action: SnackBarAction(
        label: 'Desfazer',
        onPressed: () {
          // Em caso de desfazer, retornamos "false"
          Navigator.of(context).pop(false);
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Esperamos que o usuário clique em 'Desfazer' ou no tempo de duração do Snackbar
    await Future.delayed(const Duration(seconds: 3));
    return true;
  }
}
