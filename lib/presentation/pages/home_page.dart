// lib/presentation/pages/home_page.dart (mise à jour)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/expense_state.dart';
import 'package:monbudget/presentation/bloc/them_bloc.dart';
import 'package:monbudget/presentation/pages/widgets/custom_bottom_sheet.dart';
import 'package:monbudget/presentation/pages/widgets/total_summary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExpenseBloc>();
    final themeBloc = context.read<ThemeBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes dépenses"),
        centerTitle: true,
        actions: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeBloc.add(ToggleThemeEvent());
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddExpenseSheet(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state.expenses.isEmpty) {
            return const Center(child: Text("Aucune dépense"));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TotalSummary(
                total: state.total,
                totals: state.totalsByCategory ?? {},
                budgetStatus: state.budgetStatus,
              ),
              const SizedBox(height: 20),
              const Text(
                'Historique',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.expenses.length,
                itemBuilder: (context, index) {
                  final e = state.expenses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: Text(
                        e.category.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(e.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.category.displayName,
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            e.date.toLocal().toIso8601String().split('T').first,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      trailing: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            '${e.amount.toStringAsFixed(0)} FCFA',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            iconSize: 20,
                            onPressed: () {
                              bloc.add(DeleteExpenseEvent(index: index));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
