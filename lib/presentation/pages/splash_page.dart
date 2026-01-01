import 'package:flutter/material.dart';
import 'package:monbudget/presentation/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage())),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Image.asset("lib/images/mon_budget.png"),
            CircularProgressIndicator(),
            SizedBox(height: 40),
            Text("Developer by LeloEduk"),
          ],
        ),
      ),
    );
  }
}
