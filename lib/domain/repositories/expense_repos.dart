import 'package:monbudget/domain/entities/expense.dart';

abstract class ExpenseRepos {
  List<Expense> getAllExpenses();
  void addExpense(Expense expense);
  void deleteExpense(int index);
  double getTotal();

  List<Expense> getExpensesInRange(DateTime start, DateTime end);
  Map<ExpenseCategory, double> getTotalsByCategory({
    DateTime? start,
    DateTime? end,
  });
}
