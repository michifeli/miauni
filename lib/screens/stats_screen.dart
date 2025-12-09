import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/transactions_provider.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        // Datos calculados desde el provider
        final totalIncome = provider.totalIncome;
        final totalExpense = provider.totalExpense;
        final balance = provider.currentBalance;
        final savingsRate = totalIncome > 0
            ? ((balance / totalIncome) * 100).clamp(0.0, 100.0)
            : 0.0;

        // Gastos por categoría
        final expensesByCategory = provider.getExpensesByCategory();
        final sortedCategories = expensesByCategory.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // Mes actual para mostrar en el header
        final now = DateTime.now();
        final monthFormat = DateFormat('MMMM yyyy', 'es_ES');
        final currentMonth = monthFormat.format(now);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Text('Estadísticas', style: AppTextStyles.heading2),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  currentMonth,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Estadísticas Cards - Top Row (ahora con datos reales)
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_up,
                        label: 'Ingresos',
                        amount: totalIncome,
                        color: AppColors.mintGreen,
                        textColor: AppColors.darkGreen,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_down,
                        label: 'Gastos',
                        amount: totalExpense,
                        color: const Color(0xFFFEE2E2),
                        textColor: AppColors.coral,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Estadísticas Cards - Bottom Row (ahora con datos reales)
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.savings,
                        label: 'Ahorro',
                        amount: balance,
                        color: const Color(0xFFDDEAFB),
                        textColor: const Color(0xFF1E40AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.percent,
                        label: 'Tasa ahorro',
                        percentage: savingsRate,
                        color: const Color(0xFFE9D5FF),
                        textColor: const Color(0xFF7C3AED),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Gastos por Categoría (ahora con datos reales)
                Row(
                  children: [
                    const Text('📊', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Gastos por Categoría', style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                  ),
                  child: sortedCategories.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                const Text(
                                  '📊',
                                  style: TextStyle(fontSize: 48),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No hay gastos registrados',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            // Placeholder para el gráfico circular
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.borderDark,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '📊',
                                  style: TextStyle(fontSize: 48),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Lista de categorías (datos reales)
                            ...sortedCategories.take(5).map((entry) {
                              final percentage = totalExpense > 0
                                  ? ((entry.value / totalExpense) * 100).round()
                                  : 0;
                              final colors = [
                                AppColors.mintGreen,
                                const Color(0xFFE9D5FF),
                                const Color(0xFFFEE2E2),
                                const Color(0xFFFFDDB3),
                                const Color(0xFFDDEAFB),
                              ];
                              final colorIndex =
                                  sortedCategories.indexOf(entry) %
                                  colors.length;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _CategoryItem(
                                  emoji: entry.key.split(' ')[0],
                                  label: entry.key.split(' ').skip(1).join(' '),
                                  amount: entry.value,
                                  percentage: percentage,
                                  color: colors[colorIndex],
                                ),
                              );
                            }),
                          ],
                        ),
                ),
                const SizedBox(height: 32),

                // Últimos 7 días
                Row(
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Últimos 7 días', style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('📈', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text(
                        'Gráfico de últimos 7 días',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Metas de Ahorro (placeholder por ahora)
                Row(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('Metas de Ahorro', style: AppTextStyles.heading3),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                  ),
                  child: Column(
                    children: [
                      // Por ahora, metas hardcodeadas. En el futuro, esto podría venir de otro servicio
                      _SavingsGoalItem(
                        label: 'Fondo de emergencia',
                        current: balance > 0 ? balance * 0.45 : 0,
                        goal: 100000,
                        percentage: balance > 0
                            ? ((balance * 0.45 / 100000) * 100).round()
                            : 0,
                      ),
                      const SizedBox(height: 20),
                      _SavingsGoalItem(
                        label: 'Viaje de verano',
                        current: balance > 0 ? balance * 0.32 : 0,
                        goal: 100000,
                        percentage: balance > 0
                            ? ((balance * 0.32 / 100000) * 100).round()
                            : 0,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget para las tarjetas de estadísticas
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? amount;
  final double? percentage;
  final Color color;
  final Color textColor;

  const _StatCard({
    required this.icon,
    required this.label,
    this.amount,
    this.percentage,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDark, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: textColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (amount != null)
            Text(
              '\$${amount!.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTextStyles.heading3.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            )
          else if (percentage != null)
            Text(
              '${percentage!.toStringAsFixed(1)}%',
              style: AppTextStyles.heading3.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

// Widget para items de categoría
class _CategoryItem extends StatelessWidget {
  final String emoji;
  final String label;
  final double amount;
  final int percentage;
  final Color color;

  const _CategoryItem({
    required this.emoji,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.borderDark, width: 1.5),
          ),
        ),
        const SizedBox(width: 12),
        Text(emoji, style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: AppTextStyles.bodyRegular)),
        Text(
          '\$${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
          style: AppTextStyles.bodyBold,
        ),
        const SizedBox(width: 8),
        Text(
          '($percentage%)',
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// Widget para las metas de ahorro
class _SavingsGoalItem extends StatelessWidget {
  final String label;
  final double current;
  final double goal;
  final int percentage;

  const _SavingsGoalItem({
    required this.label,
    required this.current,
    required this.goal,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodyBold),
            Text('$percentage%', style: AppTextStyles.bodyBold),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.borderDark, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFAA00),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${current.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTextStyles.caption,
            ),
            Text(
              'de \$${goal.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
