import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../services/transactions_service.dart';
import '../services/streak_service.dart';

/// Provider principal para gestionar el estado de transacciones
///
/// Usa ChangeNotifier para notificar a los widgets cuando hay cambios
/// Se comunica con TransactionsService y StreakService
class TransactionsProvider extends ChangeNotifier {
  final TransactionsService _transactionsService;
  final StreakService _streakService;

  List<Transaction> _transactions = [];
  bool _isLoading = false;

  TransactionsProvider({
    TransactionsService? transactionsService,
    StreakService? streakService,
  }) : _transactionsService =
           transactionsService ?? TransactionsService.instance,
       _streakService = streakService ?? StreakService.instance {
    _init();
  }

  // ========== GETTERS ==========

  /// Lista de todas las transacciones (ordenadas por fecha, más reciente primero)
  List<Transaction> get transactions {
    final sorted = List<Transaction>.from(_transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  /// Solo ingresos
  List<Transaction> get incomes =>
      _transactions.where((tx) => tx.type == TransactionType.income).toList();

  /// Solo gastos
  List<Transaction> get expenses =>
      _transactions.where((tx) => tx.type == TransactionType.expense).toList();

  /// Total de ingresos
  double get totalIncome {
    return incomes.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Total de gastos
  double get totalExpense {
    return expenses.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Balance neto (ingresos - gastos)
  double get currentBalance => totalIncome - totalExpense;

  /// Transacciones del mes actual
  List<Transaction> get currentMonthTransactions {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return _transactions
        .where(
          (tx) =>
              tx.date.isAfter(startOfMonth.subtract(const Duration(days: 1))),
        )
        .toList();
  }

  /// Total ingresos del mes actual
  double get currentMonthIncome {
    return currentMonthTransactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Total gastos del mes actual
  double get currentMonthExpense {
    return currentMonthTransactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  /// Balance del mes actual
  double get currentMonthBalance => currentMonthIncome - currentMonthExpense;

  /// Racha actual de ahorro
  int get currentStreak => _streakService.currentStreak;

  /// Mejor racha histórica
  int get bestStreak => _streakService.bestStreak;

  /// Indica si está cargando datos
  bool get isLoading => _isLoading;

  // ========== MÉTODOS PÚBLICOS ==========

  /// Inicialización: carga datos y configura listeners
  Future<void> _init() async {
    await loadTransactions();

    // Escuchar cambios en tiempo real desde Hive
    _transactionsService.watchTransactions().listen((txList) {
      _transactions = txList;
      _recomputeStreak();
      notifyListeners();
    });
  }

  /// Cargar todas las transacciones desde el storage
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = _transactionsService.getAllTransactions();
      await _recomputeStreak();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Agregar una nueva transacción
  Future<void> addTransaction(Transaction transaction) async {
    try {
      await _transactionsService.addTransaction(transaction);
      // El listener de watchTransactions se encargará de actualizar
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  /// Actualizar una transacción existente
  Future<void> updateTransaction(Transaction transaction) async {
    try {
      await _transactionsService.updateTransaction(transaction);
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Eliminar una transacción
  Future<void> deleteTransaction(String id) async {
    try {
      await _transactionsService.deleteTransaction(id);
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  /// Obtener transacciones por categoría
  List<Transaction> getTransactionsByCategory(String category) {
    return _transactions
        .where((tx) => tx.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  /// Obtener gastos agrupados por categoría con totales
  Map<String, double> getExpensesByCategory() {
    final Map<String, double> categoryTotals = {};

    for (final tx in expenses) {
      categoryTotals[tx.category] =
          (categoryTotals[tx.category] ?? 0) + tx.amount;
    }

    return categoryTotals;
  }

  /// Recalcular la racha basándose en transacciones actuales
  Future<void> _recomputeStreak() async {
    await _streakService.recomputeStreak(_transactions);
  }

  /// Limpiar todas las transacciones (para testing)
  Future<void> clearAll() async {
    await _transactionsService.clearAll();
    await _streakService.reset();
    _transactions = [];
    notifyListeners();
  }
}
