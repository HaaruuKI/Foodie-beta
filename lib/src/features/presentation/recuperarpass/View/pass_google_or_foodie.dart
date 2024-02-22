import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/styles/button.dart';

class PassGoogleOrFoodie extends StatefulWidget {
  const PassGoogleOrFoodie({super.key});

  @override
  State<PassGoogleOrFoodie> createState() => _PassGoogleOrFoodieState();
}

class _PassGoogleOrFoodieState extends State<PassGoogleOrFoodie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(builder: (BuildContext context) {
          return _btnBack(context, Colors.black);
        }),
      ),
      body: Form(
          child: Container(
        padding: const EdgeInsets.all(50.0),
        child: ListView(
          children: [
            const Text('¿Olvidaste tu contraseña?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35.0)),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                  'Favor de elegir de donde quiere recuperar la contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: gris,
                      fontWeight: FontWeight.w500,
                      fontSize: 17.0)),
            ),
            const SizedBox(height: 40),
            // ElevatedButton(
            //   style: buttonPrimary,
            //   onPressed: () {
            //     Navigator.pushNamed(context, 'forpassGoogle');
            //   },
            //   child: const Text('Google'),
            // ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: buttonPrimary,
              onPressed: () {
                Navigator.pushNamed(context, 'forpass');
              },
              child: const Text('Google o Foodie'),
            ),
          ],
        ),
      )),
    );
  }

//Boton con icono de flecha de retroceso
  Widget _btnBack(BuildContext context, Color color) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: color,
        size: 50.0,
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'login');
      },
    );
  }
}
