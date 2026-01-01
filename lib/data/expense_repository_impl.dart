import 'package:hive/hive.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/repositories/expense_repos.dart';

class ExpenseRepositoryImpl implements ExpenseRepos {
  final Box box;
  ExpenseRepositoryImpl(this.box);

  // ajouter
  @override
  void addExpense(Expense expense) {
    box.add({"title": expense.title, "amount": expense.amount});
  }

  //supprimer
  @override
  void deleteExpense(int index) {
    box.deleteAt(index);
  }

  // avoir la listes
  @override
  List<Expense> getAllExpenses() {
    return box.values.map((e) {
      final data = e as Map;
      return Expense(title: data["title"], amount: data["amount"]);
    }).toList();
  }

  // calculer la somme
  @override
  double getTotal() {
    return getAllExpenses().fold(0.0, (sum, item) => sum + item.amount);
  }
}
