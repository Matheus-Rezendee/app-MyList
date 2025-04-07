import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../providers/list_provider.dart';

/// Diálogo para criar nova categoria
class CategoryCreationDialog extends StatefulWidget {
  const CategoryCreationDialog({super.key});

  @override
  State<CategoryCreationDialog> createState() => _CategoryCreationDialogState();
}

class _CategoryCreationDialogState extends State<CategoryCreationDialog> {
  final _nameController = TextEditingController();
  IconData _selectedIcon = Icons.category_rounded;
  Color _selectedColor = const Color(0xFF6C5CE7);
  final Uuid uuid = Uuid();

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.work_rounded,
    Icons.shopping_basket_rounded,
    Icons.fitness_center_rounded,
    Icons.book_rounded,
    Icons.medical_services_rounded,
  ];

  final List<Color> _colors = [
    const Color(0xFF6C5CE7),
    const Color(0xFF00CEC9),
    const Color(0xFFFF7675),
    const Color(0xFFFDCB6E),
    const Color(0xFFA66EFA),
    const Color(0xFF55EFC4),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nova Categoria',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da categoria',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Selecione um ícone:'),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: _icons.length,
                itemBuilder: (context, index) => IconButton(
                  icon: Icon(
                    _icons[index],
                    color: _selectedIcon == _icons[index]
                        ? _selectedColor
                        : Colors.grey,
                  ),
                  onPressed: () => setState(() => _selectedIcon = _icons[index]),
                ),
              ),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Selecione uma cor:'),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _colors.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: Colors.black87, width: 2)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty) {
                          context.read<ListProvider>().addCategory(
                                Category(
                                  id: uuid.v4(), // Gerando o ID único aqui
                                  name: _nameController.text,
                                  icon: _selectedIcon,
                                  color: _selectedColor,
                                ),
                              );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Criar'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
