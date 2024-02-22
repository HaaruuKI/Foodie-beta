// ignore_for_file: use_build_context_synchronously, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/styles/button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _cargando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      const Image(
                        width: double.infinity,
                        height: 200.0,
                        fit: BoxFit.cover,
                        image: AssetImage('assets/LoginPage.jpg'),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 60.0),
                        child: _btnBack(context, Colors.white),
                      )
                    ],
                  ),
                  Transform.translate(
                    offset: const Offset(0.0, -50.0),
                    child: Container(
                      width: double.infinity,
                      height: 600,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('Bienvenidos',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50.0)),
                              const Text('Iniciar Sesión',
                                  style: TextStyle(
                                      color: gris,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30.0)),
                              const SizedBox(height: 40),
                              _emailInput(_emailController),
                              _passwordInput(_passwordController),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                style: buttonPrimary,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _cargando = true;
                                    });
                                    try {
                                      // Iniciar sesión con Firebase Authentication
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);

                                      User? user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        DocumentSnapshot doc =
                                            await FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(user.uid)
                                                .get();
                                        print(
                                            "Nombre (Firestore): ${doc.get('name')}");
                                        print(
                                            "Email (Firestore): ${doc.get('email')}");
                                      }
                                      // Mostrar mensaje de éxito
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Sesión iniciada correctamente')));

                                      // Redirigir al usuario al menu
                                      Navigator.pushNamed(context, 'menu');
                                    } on FirebaseAuthException catch (e) {
                                      // Mostrar mensaje de error
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(e.message!)));
                                    } finally {
                                      setState(() {
                                        _cargando = false;
                                      });
                                    }
                                  }
                                },
                                child: const Text('Iniciar sesión'),
                              ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'GoogleOrFoodie');
                                },
                                child: const Text(
                                  '¿Olvidaste tu contraseña?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 20.0),
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('¿No tienes una cuenta?',
                                        style: TextStyle(
                                            color: gris,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20.0)),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, 'registrarse');
                                      },
                                      child: const Text(' Registrate',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 247, 196, 31),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 20.0)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

Widget _emailInput(TextEditingController _emailController) {
  return Container(
    margin: const EdgeInsets.only(top: 40.0),
    padding: const EdgeInsets.only(left: 20.0),
    decoration: BoxDecoration(
        color: const Color.fromRGBO(142, 142, 147, 1.2),
        borderRadius: BorderRadius.circular(30.0)),
    child: TextFormField(
      // Wrap with TextFormField
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: 'Correo',
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'El correo no puede estar vacío';
        } else if (!value.contains('@')) {
          return 'Por favor ingrese un correo';
        }
        return null; // Returns null if validation passes
      },
    ),
  );
}

Widget _passwordInput(TextEditingController _passwordController) {
  return Container(
    margin: const EdgeInsets.only(top: 15.0),
    padding: const EdgeInsets.only(left: 20.0),
    decoration: BoxDecoration(
        color: const Color.fromRGBO(142, 142, 147, 1.2),
        borderRadius: BorderRadius.circular(30.0)),
    child: TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
          hintText: 'Contraseña',
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'La contraseña no puede estar vacía';
        }
        return null;
      },
    ),
  );
}

Widget _btnBack(BuildContext context, Color color) {
  return IconButton(
    icon: Icon(
      Icons.arrow_back_rounded,
      color: color,
      size: 50.0,
    ),
    onPressed: () {
      Navigator.pushNamed(context, 'menu');
    },
  );
}
