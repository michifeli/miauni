import 'package:hive/hive.dart';

part 'transaction.g.dart';

/// Tipo de transacción: ingreso o gasto
@HiveType(typeId: 1)
enum TransactionType {
  @HiveField(0)
  income,

  @HiveField(1)
  expense,
}

/// Modelo principal de transacción
///
/// Decisión de diseño: Usamos Hive porque:
/// - No requiere SQL (más simple que sqflite)
/// - Rápido y eficiente para almacenamiento local
/// - Perfecto para apps offline
/// - TypeAdapter generado automáticamente con build_runner
@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final TransactionType type;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final String? note;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    this.note,
  });

  /// Helper para saber si es un ingreso
  bool get isIncome => type == TransactionType.income;

  /// Helper para saber si es un gasto
  bool get isExpense => type == TransactionType.expense;

  /// Helper para obtener el monto con signo (+ para ingreso, - para gasto)
  double get signedAmount => isIncome ? amount : -amount;

  /// Copia con modificaciones
  Transaction copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return Transaction(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, type: $type, amount: $amount, category: $category, date: $date)';
  }
}
