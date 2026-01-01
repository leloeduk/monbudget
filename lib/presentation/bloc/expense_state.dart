import 'package:monbudget/domain/entities/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final double total;

  ExpenseState({required this.total, required this.expenses});
}
