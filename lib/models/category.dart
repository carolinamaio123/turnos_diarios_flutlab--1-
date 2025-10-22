import 'package:flutter/material.dart';

/// Identificadores fixos de categoria
enum CategoryId { chefia, padeiro, funcionario }

/// Modelo que contém metadados de cada categoria
class Category {
  final CategoryId id;
  final String label;
  final String letter;
  final Color color;

  const Category({
    required this.id,
    required this.label,
    required this.letter,
    required this.color,
  });
}

/// Mapa global de categorias
final Map<CategoryId, Category> categories = {
  CategoryId.chefia: Category(
    id: CategoryId.chefia,
    label: 'Chefia',
    letter: 'C',
    color: Colors.redAccent.shade700,
  ),
  CategoryId.padeiro: Category(
    id: CategoryId.padeiro,
    label: 'Padeiro',
    letter: 'P',
    color: Colors.orange.shade600,
  ),
  CategoryId.funcionario: Category(
    id: CategoryId.funcionario,
    label: 'Funcionário',
    letter: 'F',
    color: Colors.green.shade600,
  ),
};
