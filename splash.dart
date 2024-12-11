//L,L.Uvindu Thamodya IM/2021/112
import 'package:uvical/calculator_screen.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CalculatorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: const Text(
              'Uvi Calculator',
              style:  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
