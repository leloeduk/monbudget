import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monbudget/domain/entities/expense.dart';
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
  ExpenseCategory _selectedCategory = ExpenseCategory.CHARGES;
  DateTime _selectedDate = DateTime.now();

  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerReady = true),
        onAdFailedToLoad: (_, __) => setState(() => _isBannerReady = false),
      ),
      request: AdRequest(),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  Widget _categoryLabel(ExpenseCategory c) {
    switch (c) {
      case ExpenseCategory.INVESTMENT:
        return Text("Investissement");
      case ExpenseCategory.CHARGES:
        return Text("Charges");
      case ExpenseCategory.PLEASURE:
        return Text("Plaisir");
    }
  }

  Color _deltaColor(double delta) => delta >= 0 ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ExpenseBloc>();
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Mon budget")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => bloc.add(FilterByPeriodEvent('day')),
                child: Text("Jour"),
              ),
              ElevatedButton(
                onPressed: () => bloc.add(FilterByPeriodEvent('week')),
                child: Text("Semaine"),
              ),
              ElevatedButton(
                onPressed: () => bloc.add(FilterByPeriodEvent('month')),
                child: Text("Mois"),
              ),
              ElevatedButton(
                onPressed: () => bloc.add(FilterByPeriodEvent('year')),
                child: Text("Année"),
              ),
            ],
          ),
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              final totals = state.totalsByCategory ?? {};
              final total = state.total <= 0 ? 1.0 : state.total;
              double pct(ExpenseCategory c) =>
                  (totals[c] ?? 0.0) / total * 100.0;
              const targets = {
                ExpenseCategory.INVESTMENT: 40.0,
                ExpenseCategory.CHARGES: 60.0,
                ExpenseCategory.PLEASURE: 10.0,
              };

              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Total période: ${state.total.toStringAsFixed(0)} FCFA",
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: ExpenseCategory.values.map((c) {
                        final actual = pct(c);
                        final target = targets[c]!;
                        final delta = actual - target;
                        return Column(
                          children: [
                            _categoryLabel(c),
                            Text(
                              "${(totals[c] ?? 0.0).toStringAsFixed(0)} FCFA",
                            ),
                            Text(
                              "${actual.toStringAsFixed(1)}% (cible ${target.toStringAsFixed(0)}%)",
                              style: TextStyle(color: _deltaColor(delta)),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
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
                    hintText: "Entrez une dépense",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.money, color: Colors.black),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Montant",
                    hintText: "Entrez un montant",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    DropdownButton<ExpenseCategory>(
                      value: _selectedCategory,
                      items: ExpenseCategory.values.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: _categoryLabel(c),
                        );
                      }).toList(),
                      onChanged: (v) {
                        if (v != null) setState(() => _selectedCategory = v);
                      },
                    ),
                    SizedBox(width: 16),
                    TextButton(
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (d != null) setState(() => _selectedDate = d);
                      },
                      child: Text(
                        "${_selectedDate.toLocal().toIso8601String().split('T').first}",
                      ),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isEmpty ||
                            amountController.text.isEmpty)
                          return;
                        bloc.add(
                          AddExpenseEvent(
                            title: titleController.text,
                            amount:
                                double.tryParse(amountController.text) ?? 0.0,
                            category: _selectedCategory,
                            date: _selectedDate,
                          ),
                        );
                        titleController.clear();
                        amountController.clear();
                      },
                      child: Text("Ajouter"),
                    ),
                  ],
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
                    final current = state.expenses[index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
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
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(current.title),
                                Text(
                                  "${current.amount.toStringAsFixed(0)} FCFA • ${current.date.toLocal().toIso8601String().split('T').first}",
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              bloc.add(DeleteExpenseEvent(index: index));
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

          if (_isBannerReady)
            Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
}
