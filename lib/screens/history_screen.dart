import 'package:flutter/material.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _typeFilter = 'Todo'; // Todo, Ingreso, Gasto
  String _timeFilter = 'Todo'; // Todo, Hoy, 7 días, 30 días
  String? _categoryFilter; // null = todas las categorías
  bool _showFilters = false; // Controla si se muestran los filtros

  final List<String> _categories = [
    '🎓 Estudios',
    '🎉 Carrete',
    '🍔 Comida',
    '🍕 Delivery',
    '🚌 Transporte',
    '🎓 Beca',
  ];

  // Datos de ejemplo
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'expense',
      'category': '🍔 Comida',
      'description': 'Completos',
      'date': 'miércoles 10 de diciembre',
      'amount': 3000,
    },
    {
      'type': 'income',
      'category': '🎓 Beca',
      'description': '',
      'date': 'lunes 1 de diciembre',
      'amount': 30000,
    },
    {
      'type': 'expense',
      'category': '🍔 Comida',
      'description': 'Almuerzo en el mall',
      'date': 'martes 14 de enero',
      'amount': 15000,
    },
    {
      'type': 'expense',
      'category': '🚌 Transporte',
      'description': 'Uber a la U',
      'date': 'martes 14 de enero',
      'amount': 8500,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Text('📋', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text('Historial', style: AppTextStyles.heading2),
                ],
              ),
              const SizedBox(height: 16),

              // Botón de Filtros
              GestureDetector(
                onTap: () => setState(() => _showFilters = !_showFilters),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.filter_list, size: 20),
                          const SizedBox(width: 8),
                          Text('Filtros', style: AppTextStyles.bodyBold),
                          if (_typeFilter != 'Todo' ||
                              _timeFilter != 'Todo' ||
                              _categoryFilter != null)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.coral,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.borderDark,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                '●',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Icon(
                        _showFilters
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              // Filtros desplegables
              if (_showFilters) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderDark, width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _FilterChip(
                            label: 'Todo',
                            isSelected: _typeFilter == 'Todo',
                            onTap: () => setState(() => _typeFilter = 'Todo'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Ingreso',
                            isSelected: _typeFilter == 'Ingreso',
                            onTap: () =>
                                setState(() => _typeFilter = 'Ingreso'),
                            color: AppColors.mintGreen,
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Gasto',
                            isSelected: _typeFilter == 'Gasto',
                            onTap: () => setState(() => _typeFilter = 'Gasto'),
                            color: const Color(0xFFFEE2E2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: AppColors.borderDark.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Período',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(
                            label: 'Todo',
                            isSelected: _timeFilter == 'Todo',
                            onTap: () => setState(() => _timeFilter = 'Todo'),
                          ),
                          _FilterChip(
                            label: 'Hoy',
                            isSelected: _timeFilter == 'Hoy',
                            onTap: () => setState(() => _timeFilter = 'Hoy'),
                          ),
                          _FilterChip(
                            label: 'Últimos 7 días',
                            isSelected: _timeFilter == 'Últimos 7 días',
                            onTap: () =>
                                setState(() => _timeFilter = 'Últimos 7 días'),
                          ),
                          _FilterChip(
                            label: 'Últimos 30 días',
                            isSelected: _timeFilter == 'Últimos 30 días',
                            onTap: () =>
                                setState(() => _timeFilter = 'Últimos 30 días'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: AppColors.borderDark.withOpacity(0.1),
                      ),
                      const SizedBox(height: 12),

                      Text(
                        'Categoría',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(
                            label: 'Todas',
                            isSelected: _categoryFilter == null,
                            onTap: () => setState(() => _categoryFilter = null),
                          ),
                          ..._categories.map(
                            (category) => _FilterChip(
                              label: category,
                              isSelected: _categoryFilter == category,
                              onTap: () =>
                                  setState(() => _categoryFilter = category),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),

        // Lista de transacciones
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              final transaction = _transactions[index];
              final isExpense = transaction['type'] == 'expense';

              // Mostrar separador de fecha solo si es diferente al anterior
              final showDateSeparator =
                  index == 0 ||
                  _transactions[index - 1]['date'] != transaction['date'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDateSeparator) ...[
                    if (index > 0) const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          transaction['date'],
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderDark, width: 2),
                    ),
                    child: Row(
                      children: [
                        // Emoji de categoría
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isExpense
                                ? const Color(0xFFFEE2E2)
                                : AppColors.mintGreen,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.borderDark,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              transaction['category'].split(' ')[0],
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Información
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction['category']
                                    .split(' ')
                                    .skip(1)
                                    .join(' '),
                                style: AppTextStyles.bodyBold,
                              ),
                              if (transaction['description'].isNotEmpty)
                                Text(
                                  transaction['description'],
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Monto
                        Text(
                          '${isExpense ? '-' : '+'}\$${transaction['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                          style: AppTextStyles.heading3.copyWith(
                            color: isExpense
                                ? AppColors.coral
                                : AppColors.darkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// Widget para los chips de filtro
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.textPrimary) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderDark, width: 2),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
