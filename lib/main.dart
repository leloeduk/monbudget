// lib/main.dart (mise à jour)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monbudget/data/expense_repository_impl.dart';
import 'package:monbudget/presentation/bloc/expense_bloc.dart';
import 'package:monbudget/presentation/bloc/expense_event.dart';
import 'package:monbudget/presentation/bloc/them_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ExpenseBloc(ExpenseRepositoryImpl(box))..add(LoadExpenseEvent()),
        ),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mon budget',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: ThemeMode.light,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
