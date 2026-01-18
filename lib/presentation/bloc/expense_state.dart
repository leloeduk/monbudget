// lib/presentation/bloc/expense_state.dart (mise à jour)
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/services/budget_calculator.dart';

class ExpenseState {
  final List<Expense> expenses;
  final double total;
  final Map<ExpenseCategory, double>? totalsByCategory;
  final String periodLabel;
  final BudgetStatus? budgetStatus;

  ExpenseState({
    required this.expenses,
    required this.total,
    this.totalsByCategory,
    this.periodLabel = '',
    this.budgetStatus,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    double? total,
    Map<ExpenseCategory, double>? totalsByCategory,
    String? periodLabel,
    BudgetStatus? budgetStatus,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      total: total ?? this.total,
      totalsByCategory: totalsByCategory ?? this.totalsByCategory,
      periodLabel: periodLabel ?? this.periodLabel,
      budgetStatus: budgetStatus ?? this.budgetStatus,
    );
  }
}
