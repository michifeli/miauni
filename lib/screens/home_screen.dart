import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';
import '../widgets/balance_card.dart';
import '../widgets/action_button.dart';
import '../widgets/budget_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wena',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text('Mitchel', style: AppTextStyles.heading2),
                          const SizedBox(width: 4),
                          const Text('✌️', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Balance Card
              const BalanceCard(
                balance: 27000,
                income: 30000,
                expense: 30000,
                daysLeft: 5,
              ),
              const SizedBox(height: 24),

              // Pixel Cat Message
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark, width: 2),
                ),
                child: Row(
                  children: [
                    // Pixel cat image (usando un placeholder por ahora)
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.mintGreen,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.borderDark,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text('🐱', style: TextStyle(fontSize: 32)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deja de comer completos!!¡',
                            style: AppTextStyles.bodyBold,
                          ),
                          Text('O MORIRE 💀', style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              ActionButton(
                label: 'GASTO',
                icon: Icons.remove,
                backgroundColor: AppColors.coral,
                onPressed: () {
                  // TODO: Implementar navegación a agregar gasto
                },
              ),
              const SizedBox(height: 12),
              ActionButton(
                label: 'INGRESO',
                icon: Icons.add,
                backgroundColor: AppColors.teal,
                onPressed: () {
                  // TODO: Implementar navegación a agregar ingreso
                },
              ),
              const SizedBox(height: 24),

              // Budget Cards
              Row(
                children: [
                  BudgetCard(
                    label: 'Presupuesto',
                    icon: Icons.anchor,
                    amount: 300000,
                    subtitle: '2 movimientos',
                  ),
                  const SizedBox(width: 12),
                  BudgetCard(
                    label: 'Este mes',
                    icon: Icons.calendar_today,
                    amount: 0,
                    subtitle: '2 movimientos',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
