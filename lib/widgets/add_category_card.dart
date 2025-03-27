import 'package:flutter/material.dart';

/// Card para adicionar nova categoria
class AddCategoryCard extends StatelessWidget {
  final VoidCallback onTap;
  const AddCategoryCard({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.transparent, // Mantém o fundo do card
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_rounded, size: 50, color: Theme.of(context).primaryColor),
                const SizedBox(height: 12),
                Text(
                  'Criar Nova Lista',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
