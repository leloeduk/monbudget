// lib/domain/services/budget_calculator.dart
import 'dart:ui';

import 'package:monbudget/domain/entities/expense.dart';

class BudgetStatus {
  final double needsAmount; // 50% - Dépenses essentielles
  final double wantsAmount; // 40% - Loisirs/Plaisir
  final double investmentAmount; // 10% - Investissements
  final double totalIncome;
  final double needsUsed;
  final double wantsUsed;
  final double investmentUsed;

  bool get isNeedsSafe => needsUsed <= needsAmount;
  bool get isWantsSafe => wantsUsed <= wantsAmount;
  bool get isInvestmentSafe => investmentUsed <= investmentAmount;
  bool get isGlobalSafe =>
      needsUsed <= needsAmount &&
      wantsUsed <= wantsAmount &&
      investmentUsed <= investmentAmount;

  double get needsPercentage =>
      totalIncome > 0 ? (needsUsed / needsAmount * 100) : 0;
  double get wantsPercentage =>
      totalIncome > 0 ? (wantsUsed / wantsAmount * 100) : 0;
  double get investmentPercentage =>
      totalIncome > 0 ? (investmentUsed / investmentAmount * 100) : 0;

  BudgetStatus({
    required this.needsAmount,
    required this.wantsAmount,
    required this.investmentAmount,
    required this.totalIncome,
    required this.needsUsed,
    required this.wantsUsed,
    required this.investmentUsed,
  });

  factory BudgetStatus.empty() {
    return BudgetStatus(
      needsAmount: 0,
      wantsAmount: 0,
      investmentAmount: 0,
      totalIncome: 0,
      needsUsed: 0,
      wantsUsed: 0,
      investmentUsed: 0,
    );
  }
}

class BudgetCalculator {
  static const double NEEDS_RATIO = 0.5; // 50%
  static const double WANTS_RATIO = 0.4; // 40%
  static const double INVESTMENT_RATIO = 0.1; // 10%

  static BudgetStatus calculateBudgetStatus(
    List<Expense> expenses,
    double totalIncome,
  ) {
    final needsAmount = totalIncome * NEEDS_RATIO;
    final wantsAmount = totalIncome * WANTS_RATIO;
    final investmentAmount = totalIncome * INVESTMENT_RATIO;

    double needsUsed = 0;
    double wantsUsed = 0;
    double investmentUsed = 0;

    for (final expense in expenses) {
      switch (expense.category) {
        case ExpenseCategory.CHARGES:
          needsUsed += expense.amount;
          break;
        case ExpenseCategory.PLEASURE:
          wantsUsed += expense.amount;
          break;
        case ExpenseCategory.INVESTMENT:
          investmentUsed += expense.amount;
          break;
      }
    }

    return BudgetStatus(
      needsAmount: needsAmount,
      wantsAmount: wantsAmount,
      investmentAmount: investmentAmount,
      totalIncome: totalIncome,
      needsUsed: needsUsed,
      wantsUsed: wantsUsed,
      investmentUsed: investmentUsed,
    );
  }

  static String getStatus(BudgetStatus status) {
    if (!status.isGlobalSafe) {
      if (!status.isNeedsSafe) return "⚠️ Charges trop élevées!";
      if (!status.isWantsSafe) return "⚠️ Loisirs trop élevés!";
      if (!status.isInvestmentSafe) return "⚠️ Investissements trop élevés!";
    }
    return "✅ Budget respecté!";
  }

  static Color getStatusColor(BudgetStatus status) {
    if (!status.isGlobalSafe) return Color(0xFFFF6B6B); // Rouge
    return Color(0xFF51CF66); // Vert
  }
}
