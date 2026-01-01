import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/domain/repositories/expense_repos.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepos repository;
  ExpenseBloc(this.repository) : super(ExpenseState(expenses: [], total: 0)) {
    on<LoadExpenseEvent>((event, emit) {
      emit(
        ExpenseState(
          expenses: repository.getAllExpenses(),
          total: repository.getTotal(),
        ),
      );
    });

    on<AddExpenseEvent>((event, emit) {
      repository.addExpense(Expense(title: event.title, amount: event.amount));
      emit(
        ExpenseState(
          expenses: repository.getAllExpenses(),
          total: repository.getTotal(),
        ),
      );
    });

    on<DeleteExpenseEvent>((event, emit) {
      repository.deleteExpense(event.index);

      emit(
        ExpenseState(
          expenses: repository.getAllExpenses(),
          total: repository.getTotal(),
        ),
      );
    });
  }
}
