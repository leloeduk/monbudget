import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monbudget/data/expense_repository_impl.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox("expenses");
  MobileAds.instance.initialize();
  runApp(MyApp(box));
}

class MyApp extends StatelessWidget {
  final Box box;
  const MyApp(this.box, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ExpenseBloc(ExpenseRepositoryImpl(box))..add(LoadExpenseEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mon budget',
        darkTheme: ThemeData.dark(),
        home: SplashPage(),
      ),
    );
  }
}
