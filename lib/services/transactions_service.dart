import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

/// Servicio para gestionar transacciones con Hive
///
/// Decisión de diseño:
/// - Singleton pattern para tener una única instancia
/// - Usa LazyBox para mejor performance (solo carga datos cuando se necesitan)
/// - Expone Stream para que la UI se actualice automáticamente
class TransactionsService {
  static const String _boxName = 'transactions';

  static TransactionsService? _instance;
  Box<Transaction>? _box;

  TransactionsService._();

  /// Singleton instance
  static TransactionsService get instance {
    _instance ??= TransactionsService._();
    return _instance!;
  }

  /// Inicializa Hive y abre la box de transacciones
  /// Debe llamarse en main() antes de runApp()
  Future<void> init() async {
    await Hive.initFlutter();

    // Registrar adaptadores (solo una vez)
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TransactionTypeAdapter());
    }

    // Abrir box
    _box = await Hive.openBox<Transaction>(_boxName);
  }

  /// Getter para la box (lanza error si no está inicializada)
  Box<Transaction> get _transactionsBox {
    if (_box == null) {
      throw Exception(
        'TransactionsService no ha sido inicializado. Llama a init() primero.',
      );
    }
    return _box!;
  }

  /// Agregar una nueva transacción
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  /// Actualizar una transacción existente
  Future<void> updateTransaction(Transaction transaction) async {
    await _transactionsBox.put(transaction.id, transaction);
  }

  /// Eliminar una transacción por ID
  Future<void> deleteTransaction(String id) async {
    await _transactionsBox.delete(id);
  }

  /// Obtener todas las transacciones como lista
  List<Transaction> getAllTransactions() {
    return _transactionsBox.values.toList();
  }

  /// Obtener una transacción específica por ID
  Transaction? getTransaction(String id) {
    return _transactionsBox.get(id);
  }

  /// Stream que emite la lista completa cada vez que hay cambios
  /// Perfecto para usar con StreamBuilder o Provider
  Stream<List<Transaction>> watchTransactions() {
    return _transactionsBox.watch().map((_) {
      return getAllTransactions();
    });
  }

  /// Obtener transacciones filtradas por tipo
  List<Transaction> getTransactionsByType(TransactionType type) {
    return getAllTransactions().where((tx) => tx.type == type).toList();
  }

  /// Obtener transacciones de un rango de fechas
  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return getAllTransactions()
        .where(
          (tx) =>
              tx.date.isAfter(start.subtract(const Duration(days: 1))) &&
              tx.date.isBefore(end.add(const Duration(days: 1))),
        )
        .toList();
  }

  /// Obtener transacciones del mes actual
  List<Transaction> getCurrentMonthTransactions() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return getTransactionsByDateRange(startOfMonth, endOfMonth);
  }

  /// Limpiar todas las transacciones (útil para testing)
  Future<void> clearAll() async {
    await _transactionsBox.clear();
  }

  /// Cerrar la box (llamar al cerrar la app si es necesario)
  Future<void> close() async {
    await _transactionsBox.close();
  }
}
