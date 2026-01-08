import 'package:hive/hive.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/repositories/expense_repos.dart';

class ExpenseRepositoryImpl implements ExpenseRepos {
  final Box box;
  ExpenseRepositoryImpl(this.box);

  @override
  void addExpense(Expense expense) {
    box.add({
      "id": expense.id,
      "title": expense.title,
      "amount": expense.amount,
      "category": expense.category.toString().split('.').last,
      "date": expense.date.millisecondsSinceEpoch,
    });
  }

  @override
  void deleteExpense(int index) {
    box.deleteAt(index);
  }

  List<Expense> _mapAll() {
    return box.values.map((e) {
      final data = Map<String, dynamic>.from(e as Map);
      final catStr = data["category"] as String? ?? "CHARGES";
      final category = ExpenseCategory.values.firstWhere(
        (c) => c.toString().split('.').last == catStr,
        orElse: () => ExpenseCategory.CHARGES,
      );
      return Expense(
        id:
            data["id"]?.toString() ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: data["title"] ?? '',
        amount: (data["amount"] is num)
            ? (data["amount"] as num).toDouble()
            : double.tryParse("${data["amount"]}") ?? 0.0,
        category: category,
        date: DateTime.fromMillisecondsSinceEpoch(
          data["date"] ?? DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }).toList();
  }

  @override
  List<Expense> getAllExpenses() {
    return _mapAll();
  }

  @override
  double getTotal() {
    return getAllExpenses().fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  List<Expense> getExpensesInRange(DateTime start, DateTime end) {
    return getAllExpenses()
        .where((e) => !e.date.isBefore(start) && !e.date.isAfter(end))
        .toList();
  }

  @override
  Map<ExpenseCategory, double> getTotalsByCategory({
    DateTime? start,
    DateTime? end,
  }) {
    final list = (start != null && end != null)
        ? getExpensesInRange(start, end)
        : getAllExpenses();
    final map = <ExpenseCategory, double>{
      ExpenseCategory.INVESTMENT: 0.0,
      ExpenseCategory.CHARGES: 0.0,
      ExpenseCategory.PLEASURE: 0.0,
    };
    for (final e in list) {
      map[e.category] = map[e.category]! + e.amount;
    }
    return map;
  }
}
