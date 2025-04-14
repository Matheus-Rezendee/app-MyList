import 'package:flutter/material.dart';
import '../models/item.dart';

class AddItemDialog extends StatefulWidget {
  final String categoryId;
  final Item? existingItem; // ✅ Novo parâmetro opcional para edição

  const AddItemDialog({
    Key? key,
    required this.categoryId,
    this.existingItem,
  }) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
        text: widget.existingItem?.title ?? '');
    _quantityController = TextEditingController(
        text: widget.existingItem?.quantity.toString() ?? '');
    _priceController = TextEditingController(
        text: widget.existingItem?.price?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
  if (_formKey.currentState!.validate()) {
    final title = _titleController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 1;
    final priceText = _priceController.text.trim().replaceAll(',', '.');
    final price = double.tryParse(priceText) ?? 0.0;

    final item = Item(
      id: widget.existingItem?.id ?? UniqueKey().toString(),
      title: title,
      quantity: quantity,
      price: price,
      categoryId: widget.categoryId,
      isDone: widget.existingItem?.isDone ?? false,
      userId: widget.existingItem?.userId ?? 'default_user', // 🔁 substitua pelo usuário real se tiver
      createdAt: widget.existingItem?.createdAt ?? DateTime.now(),
      updatedAt: widget.existingItem != null ? DateTime.now() : null,
    );

    Navigator.of(context).pop(item);
  }
}




  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingItem != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Item' : 'Novo Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Nome do item'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Digite um nome' : null,
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Digite uma quantidade' : null,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Preço (opcional)'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C5CE7),
          ),
          child: Text(isEditing ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}
