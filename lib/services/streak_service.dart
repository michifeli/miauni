import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';

/// Servicio para gestionar la lógica de racha (streak) de ahorro
///
/// Reglas de racha:
/// - Se cuenta un día si hay al menos 1 ingreso con categoría "Ahorro" o "Beca"
/// - Los días deben ser consecutivos (sin saltos)
/// - Si pasa un día sin registro de ahorro, la racha se resetea
/// - Se guarda currentStreak y bestStreak en Hive
class StreakService {
  static const String _boxName = 'streak_data';
  static const String _currentStreakKey = 'current_streak';
  static const String _bestStreakKey = 'best_streak';
  static const String _lastStreakDateKey = 'last_streak_date';

  static StreakService? _instance;
  Box? _box;

  StreakService._();

  /// Singleton instance
  static StreakService get instance {
    _instance ??= StreakService._();
    return _instance!;
  }

  /// Inicializa el servicio (llamar después de Hive.initFlutter())
  Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  Box get _streakBox {
    if (_box == null) {
      throw Exception(
        'StreakService no ha sido inicializado. Llama a init() primero.',
      );
    }
    return _box!;
  }

  /// Obtiene la racha actual
  int get currentStreak => _streakBox.get(_currentStreakKey, defaultValue: 0);

  /// Obtiene la mejor racha histórica
  int get bestStreak => _streakBox.get(_bestStreakKey, defaultValue: 0);

  /// Obtiene la última fecha con racha registrada
  DateTime? get lastStreakDate {
    final timestamp = _streakBox.get(_lastStreakDateKey);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  /// Recalcula la racha basándose en todas las transacciones
  ///
  /// Lógica:
  /// 1. Filtra transacciones de tipo income con categoría de ahorro
  /// 2. Agrupa por fecha (día completo, sin hora)
  /// 3. Ordena de más reciente a más antigua
  /// 4. Cuenta días consecutivos desde hoy hacia atrás
  Future<void> recomputeStreak(List<Transaction> allTransactions) async {
    // Filtrar solo ingresos de ahorro/beca
    final savingsTransactions = allTransactions
        .where(
          (tx) =>
              tx.type == TransactionType.income &&
              (tx.category.toLowerCase().contains('ahorro') ||
                  tx.category.toLowerCase().contains('beca')),
        )
        .toList();

    if (savingsTransactions.isEmpty) {
      await _updateStreak(0);
      return;
    }

    // Agrupar por fecha (solo día, sin hora)
    final datesWithSavings =
        savingsTransactions
            .map((tx) => DateTime(tx.date.year, tx.date.month, tx.date.day))
            .toSet()
            .toList()
          ..sort((a, b) => b.compareTo(a)); // Más reciente primero

    // Calcular racha consecutiva desde hoy
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int streak = 0;
    DateTime expectedDate = todayDate;

    for (final date in datesWithSavings) {
      // Si la fecha coincide con la esperada, incrementa la racha
      if (_isSameDay(date, expectedDate)) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else {
        // Si hay un salto, la racha se rompe
        break;
      }
    }

    await _updateStreak(streak);
  }

  /// Actualiza la racha actual y la mejor racha si es necesario
  Future<void> _updateStreak(int newStreak) async {
    await _streakBox.put(_currentStreakKey, newStreak);

    // Actualizar última fecha de racha
    if (newStreak > 0) {
      await _streakBox.put(
        _lastStreakDateKey,
        DateTime.now().toIso8601String(),
      );
    }

    // Actualizar mejor racha si la actual es mayor
    if (newStreak > bestStreak) {
      await _streakBox.put(_bestStreakKey, newStreak);
    }
  }

  /// Chequea si una transacción incrementaría la racha
  /// Útil para mostrar feedback inmediato al usuario
  bool wouldIncrementStreak(Transaction transaction) {
    if (transaction.type != TransactionType.income) return false;

    final category = transaction.category.toLowerCase();
    return category.contains('ahorro') || category.contains('beca');
  }

  /// Helper para comparar solo día (sin hora)
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Resetea las estadísticas de racha (útil para testing)
  Future<void> reset() async {
    await _streakBox.clear();
  }
}
