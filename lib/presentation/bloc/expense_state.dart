import 'package:monbudget/domain/entities/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final double total;
  final Map<ExpenseCategory, double>? totalsByCategory;
  final String periodLabel;

  ExpenseState({
    required this.expenses,
    required this.total,
    this.totalsByCategory,
    this.periodLabel = '',
  });
}
