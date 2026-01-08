import 'package:monbudget/domain/entities/expense.dart';

abstract class ExpenseEvent {}

class LoadExpenseEvent extends ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  AddExpenseEvent({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}

class DeleteExpenseEvent extends ExpenseEvent {
  final int index;

  DeleteExpenseEvent({required this.index});
}

class LoadAnalyticsEvent extends ExpenseEvent {
  final DateTime start;
  final DateTime end;
  LoadAnalyticsEvent({required this.start, required this.end});
}

class FilterByPeriodEvent extends ExpenseEvent {
  final String period; // 'day'|'week'|'month'|'year'
  FilterByPeriodEvent(this.period);
}
