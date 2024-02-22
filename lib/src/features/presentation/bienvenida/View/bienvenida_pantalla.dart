import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();

    // Simulamos un retraso de 2 segundos antes de navegar a la pantalla de inicio de sesión
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, 'menu');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Es el estilo del container del background
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/WelcomeBG.jpeg'),
/*Imagen desde internet.
image: NetworkImage('https://images.pexels.com/photos/1583884/pexels-photo-1583884.jpeg')*/
            )),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Image.asset('assets/my-Logo.png'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
