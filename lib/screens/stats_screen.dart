import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 8),
            Text(
              'Diciembre 2025',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Estadísticas Cards - Top Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_up,
                    label: 'Ingresos',
                    amount: 30000,
                    color: AppColors.mintGreen,
                    textColor: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.trending_down,
                    label: 'Gastos',
                    amount: 3000,
                    color: const Color(0xFFFEE2E2),
                    textColor: AppColors.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Estadísticas Cards - Bottom Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.savings,
                    label: 'Ahorro',
                    amount: 27000,
                    color: const Color(0xFFDDEAFB),
                    textColor: const Color(0xFF1E40AF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.percent,
                    label: 'Tasa ahorro',
                    percentage: 90.0,
                    color: const Color(0xFFE9D5FF),
                    textColor: const Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Gastos por Categoría
            Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 20)),
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
              child: Column(
                children: [
                  // Placeholder para el gráfico circular
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.borderDark, width: 2),
                    ),
                    child: Center(
                      child: Text('📊', style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lista de categorías
                  _CategoryItem(
                    emoji: '🎓',
                    label: 'Estudios',
                    amount: 35000,
                    percentage: 34,
                    color: AppColors.mintGreen,
                  ),
                  const SizedBox(height: 12),
                  _CategoryItem(
                    emoji: '🎉',
                    label: 'Carrete',
                    amount: 25000,
                    percentage: 24,
                    color: const Color(0xFFE9D5FF),
                  ),
                  const SizedBox(height: 12),
                  _CategoryItem(
                    emoji: '🍔',
                    label: 'Comida',
                    amount: 23500,
                    percentage: 23,
                    color: const Color(0xFFFEE2E2),
                  ),
                  const SizedBox(height: 12),
                  _CategoryItem(
                    emoji: '🍕',
                    label: 'Delivery',
                    amount: 12000,
                    percentage: 12,
                    color: const Color(0xFFFFDDB3),
                  ),
                  const SizedBox(height: 12),
                  _CategoryItem(
                    emoji: '🚌',
                    label: 'Transporte',
                    amount: 8500,
                    percentage: 8,
                    color: const Color(0xFFDDEAFB),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Últimos 7 días
            Row(
              children: [
                const Text('📈', style: TextStyle(fontSize: 20)),
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

            // Metas de Ahorro
            Row(
              children: [
                const Text('🎯', style: TextStyle(fontSize: 20)),
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
                  _SavingsGoalItem(
                    label: 'Fondo de emergencia',
                    current: 45000,
                    goal: 100000,
                    percentage: 45,
                  ),
                  const SizedBox(height: 20),
                  _SavingsGoalItem(
                    label: 'Viaje de verano',
                    current: 32000,
                    goal: 100000,
                    percentage: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
