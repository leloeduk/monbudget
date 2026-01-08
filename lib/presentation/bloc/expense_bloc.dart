import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/repositories/expense_repos.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/expense_state.dart';
import 'package:uuid/uuid.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepos repository;
  final _uuid = Uuid();

  ExpenseBloc(this.repository) : super(ExpenseState(expenses: [], total: 0)) {
    on<LoadExpenseEvent>((event, emit) {
      final expenses = repository.getAllExpenses();
      emit(ExpenseState(expenses: expenses, total: repository.getTotal()));
    });

    on<AddExpenseEvent>((event, emit) {
      final expense = Expense(
        id: _uuid.v4(),
        title: event.title,
        amount: event.amount,
        category: event.category,
        date: event.date,
      );
      repository.addExpense(expense);
      final expenses = repository.getAllExpenses();
      emit(ExpenseState(expenses: expenses, total: repository.getTotal()));
    });

    on<DeleteExpenseEvent>((event, emit) {
      repository.deleteExpense(event.index);
      final expenses = repository.getAllExpenses();
      emit(ExpenseState(expenses: expenses, total: repository.getTotal()));
    });

    on<LoadAnalyticsEvent>((event, emit) {
      final expenses = repository.getExpensesInRange(event.start, event.end);
      final total = expenses.fold(0.0, (s, e) => s + e.amount);
      final totalsByCategory = repository.getTotalsByCategory(
        start: event.start,
        end: event.end,
      );
      emit(
        ExpenseState(
          expenses: expenses,
          total: total,
          totalsByCategory: totalsByCategory,
          periodLabel:
              "${event.start.toIso8601String()} - ${event.end.toIso8601String()}",
        ),
      );
    });

    on<FilterByPeriodEvent>((event, emit) {
      final now = DateTime.now();
      late DateTime start;
      late DateTime end;
      switch (event.period) {
        case 'day':
          start = DateTime(now.year, now.month, now.day);
          end = start
              .add(Duration(days: 1))
              .subtract(Duration(milliseconds: 1));
          break;
        case 'week':
          final weekday = now.weekday;
          start = DateTime(
            now.year,
            now.month,
            now.day,
          ).subtract(Duration(days: weekday - 1));
          end = start
              .add(Duration(days: 7))
              .subtract(Duration(milliseconds: 1));
          break;
        case 'month':
          start = DateTime(now.year, now.month, 1);
          end = DateTime(
            now.year,
            now.month + 1,
            1,
          ).subtract(Duration(milliseconds: 1));
          break;
        case 'year':
          start = DateTime(now.year, 1, 1);
          end = DateTime(
            now.year + 1,
            1,
            1,
          ).subtract(Duration(milliseconds: 1));
          break;
        default:
          start = DateTime(now.year, now.month, now.day);
          end = now;
      }
      add(LoadAnalyticsEvent(start: start, end: end));
    });
  }
}
