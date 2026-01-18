// lib/presentation/pages/widgets/custom_bottom_sheet.dart (mise à jour)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monbudget/domain/entities/expense.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';

void showAddExpenseSheet(BuildContext context) {
  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  ExpenseCategory category = ExpenseCategory.CHARGES;
  DateTime date = DateTime.now();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Ajouter une dépense",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(
                labelText: "Dépense",
                prefixIcon: Icon(Icons.receipt),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Montant",
                prefixIcon: Icon(Icons.payments),
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<ExpenseCategory>(
              value: category,
              items: ExpenseCategory.values.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text('${c.icon} ${c.displayName}'),
                );
              }).toList(),
              onChanged: (v) => category = v!,
              decoration: const InputDecoration(labelText: "Catégorie"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.read<ExpenseBloc>().add(
                  AddExpenseEvent(
                    title: titleCtrl.text,
                    amount: double.tryParse(amountCtrl.text) ?? 0,
                    category: category,
                    date: date,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Ajouter"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
