import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weatherflix/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=> WeatherApp(),
      ),
      );
    });
  }
  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color:Colors.blue,
          child: SizedBox(
            height: 50,
            width: 50,
            child: Container(
              height: 100,
              width: 100,
              child: Image.asset("assets/app.png",width: 50,height: 50),
            )
          ),
        ),
      ),
    );
  }
}