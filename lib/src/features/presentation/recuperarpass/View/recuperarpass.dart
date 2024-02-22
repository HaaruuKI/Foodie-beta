// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/styles/button.dart';

class RecuperarPass extends StatefulWidget {
  const RecuperarPass({super.key});

  @override
  State<RecuperarPass> createState() => _RecuperarPassState();
}

class _RecuperarPassState extends State<RecuperarPass> {
  final _emailController = TextEditingController();

  final bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Builder(builder: (BuildContext context) {
            return _btnBack(context, Colors.black);
          }),
        ),
        body: _cargando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                            '¿Olvidaste tu contraseña  Google o Foodie?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 35.0)),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        child: const Text(
                            'Favor de introducir su correo electrónico. Recibira un link para restablecer su contraseña',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: gris,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      ),
                      _emailInput(_emailController),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        style: buttonPrimary,
                        onPressed: () async {
                          _verificarDatos(
                              context, _emailController, _cargando, setState);
                        },
                        child: const Text('Recuperar contraseña'),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

void _verificarDatos(
    BuildContext context,
    TextEditingController _emailController,
    bool _cargando,
    Function setState) async {
  if (_emailController.text.isNotEmpty) {
    setState(() {
      _cargando = true;
    });

    try {
      // Enviar correo electrónico para recuperar la contraseña
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Se ha enviado un correo electrónico para recuperar la contraseña')));

      // Redirigir al usuario a la pantalla de inicio de sesión
      Navigator.pushNamed(context, 'login');
    } on FirebaseAuthException catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }
}

//Crear entrada para el email
Widget _emailInput(TextEditingController _emailController) {
  return Container(
    margin: const EdgeInsets.only(top: 40.0),
    padding: const EdgeInsets.only(left: 20.0),
    decoration: BoxDecoration(
        color: const Color.fromRGBO(142, 142, 147, 1.2),
        borderRadius: BorderRadius.circular(30.0)),
    child: TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Email',
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'El email no puede estar vacío';
        }
        return null;
      },
    ),
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
      Navigator.pushNamed(context, 'GoogleOrFoodie');
    },
  );
}
