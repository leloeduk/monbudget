// lib/domain/entities/expense.dart (mise à jour)
// ignore: constant_identifier_names
enum ExpenseCategory { INVESTMENT, CHARGES, PLEASURE }

extension ExpenseCategoryExt on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.INVESTMENT:
        return 'Investissement';
      case ExpenseCategory.CHARGES:
        return 'Charges';
      case ExpenseCategory.PLEASURE:
        return 'Plaisir';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.INVESTMENT:
        return '📈';
      case ExpenseCategory.CHARGES:
        return '💰';
      case ExpenseCategory.PLEASURE:
        return '🎉';
    }
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
