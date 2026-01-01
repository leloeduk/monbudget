abstract class ExpenseEvent {}

// chargement
class LoadExpenseEvent extends ExpenseEvent {}

// faire ajout
class AddExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;

  AddExpenseEvent({required this.title, required this.amount});
}

// faire la suppression
class DeleteExpenseEvent extends ExpenseEvent {
  final int index;

  DeleteExpenseEvent({required this.index});
}
