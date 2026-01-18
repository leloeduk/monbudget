// lib/presentation/pages/statistics_page.dart (mise à jour)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/services/budget_calculator.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/expense_state.dart';
import 'package:monbudget/presentation/pages/widgets/budget_card.dart';
import 'package:monbudget/presentation/pages/widgets/total_summary.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExpenseBloc>();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistiques")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _btn("Jour", () => bloc.add(FilterByPeriodEvent('day'))),
                _btn("Semaine", () => bloc.add(FilterByPeriodEvent('week'))),
                _btn("Mois", () => bloc.add(FilterByPeriodEvent('month'))),
                _btn("Année", () => bloc.add(FilterByPeriodEvent('year'))),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                final totals = state.totalsByCategory ?? {};
                final charges = totals[ExpenseCategory.CHARGES] ?? 0;
                final pleasure = totals[ExpenseCategory.PLEASURE] ?? 0;
                final investment = totals[ExpenseCategory.INVESTMENT] ?? 0;
                final total = state.total;

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    TotalSummary(
                      total: total,
                      totals: totals,
                      budgetStatus: state.budgetStatus,
                      periodLabel: state.periodLabel,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Budget 50/40/10',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (state.budgetStatus != null &&
                        state.budgetStatus!.totalIncome > 0)
                      Column(
                        children: [
                          BudgetCard(
                            title: 'Charges',
                            used: charges,
                            limit: state.budgetStatus!.needsAmount,
                            color: Colors.orange,
                            emoji: '💰',
                          ),
                          const SizedBox(height: 12),
                          BudgetCard(
                            title: 'Loisirs',
                            used: pleasure,
                            limit: state.budgetStatus!.wantsAmount,
                            color: Colors.purple,
                            emoji: '🎉',
                          ),
                          const SizedBox(height: 12),
                          BudgetCard(
                            title: 'Investissements',
                            used: investment,
                            limit: state.budgetStatus!.investmentAmount,
                            color: Colors.green,
                            emoji: '📈',
                          ),
                        ],
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Aucune dépense pour cette période',
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _btn(String text, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(text),
    );
  }
}
