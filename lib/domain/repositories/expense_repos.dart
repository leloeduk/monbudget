import 'package:monbudget/domain/entities/expense.dart';

abstract class ExpenseRepos {
  List<Expense> getAllExpenses();
  void addExpense(Expense expense);
  void deleteExpense(int index);
  double getTotal();
}
