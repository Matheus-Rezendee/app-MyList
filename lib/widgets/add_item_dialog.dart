import 'package:flutter/material.dart';
import '../models/item.dart';

/// Diálogo para adicionar novo item
class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Novo Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do item',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço unitário',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty || double.tryParse(value) == null 
                    ? 'Valor inválido' 
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty || int.tryParse(value) == null 
                    ? 'Valor inválido' 
                    : null,
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
                        if (_formKey.currentState!.validate()) {
                          final newItem = Item(
                            name: _nameController.text,
                            price: double.parse(_priceController.text),
                            quantity: int.parse(_quantityController.text),
                          );
                          Navigator.pop(context, newItem);
                        }
                      },
                      child: const Text('Adicionar'),
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