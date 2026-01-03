import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/expense_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Mon budget")),
      body: Column(
        children: [
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    children: [
                      Text("Total des dépenses "),
                      Text("${state.total.toStringAsFixed(0)} FCFA"),
                    ],
                  ),
                ),
              );
            },
          ),

          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.account_balance,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Dépense",
                    hintText: "Entre un mot pour une dépense",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Prix",
                    hintText: "Entre un montant",
                    border: OutlineInputBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      return;
                    }

                    context.read<ExpenseBloc>().add(
                      AddExpenseEvent(
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                      ),
                    );
                    titleController.clear();
                    amountController.clear();
                  },
                  child: Text("Ajout|er"),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: state.expenses.length,
                  itemBuilder: (context, index) {
                    final currentIndex = state.expenses[index];

                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.red.shade100,
                            ),
                            child: Icon(Icons.remove_circle_outline),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(currentIndex.title),
                              Text("${currentIndex.amount}  FCFA"),
                            ],
                          ),

                          IconButton(
                            onPressed: () {
                              context.read<ExpenseBloc>().add(
                                DeleteExpenseEvent(index: index),
                              );
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
