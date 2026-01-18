// lib/presentation/pages/widgets/total_summary.dart
import 'package:flutter/material.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/services/budget_calculator.dart';

class TotalSummary extends StatelessWidget {
  final double total;
  final Map<ExpenseCategory, double> totals;
  final BudgetStatus? budgetStatus;
  final String periodLabel;

  const TotalSummary({
    Key? key,
    required this.total,
    required this.totals,
    this.budgetStatus,
    this.periodLabel = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final charges = totals[ExpenseCategory.CHARGES] ?? 0;
    final pleasure = totals[ExpenseCategory.PLEASURE] ?? 0;
    final investment = totals[ExpenseCategory.INVESTMENT] ?? 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade400, Colors.blue.shade700],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (periodLabel.isNotEmpty)
            Text(
              periodLabel,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          const SizedBox(height: 8),
          Text(
            'Total: ${total.toStringAsFixed(0)} FCFA',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCategoryTotal('💰 Charges', charges),
              _buildCategoryTotal('🎉 Plaisir', pleasure),
              _buildCategoryTotal('📈 Investissement', investment),
            ],
          ),
          if (budgetStatus != null && budgetStatus!.totalIncome > 0) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    BudgetCalculator.getStatus(budgetStatus!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryTotal(String label, double amount) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(0)}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
