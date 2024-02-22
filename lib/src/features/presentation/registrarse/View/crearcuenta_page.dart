// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/styles/button.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _numeroController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _cargando = false;

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
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Center(
                    child: Text(
                      "Crear una cuenta",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                  _userName(context, _nombreController),
                  _lastName(context, _apellidoController),
                  _emailTextfield(context, _emailController),
                  _phoneTextfield(context, _numeroController),
                  _passwordTextfield(context, _passwordController),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    style: buttonPrimary,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _cargando = true;
                        });

                        try {
                          // Registrar usuario en Firebase Authentication
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text);

                          // Obtener uid del usuario
                          final uid = userCredential.user!.uid;

                          // Crear un nuevo documento en Firestore con el uid del usuario
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(uid)
                              .set({
                            'name': _nombreController.text,
                            'lastname': _apellidoController.text,
                            'email': _emailController.text,
                            'numero': _numeroController.text,
                          });

                          // Mostrar mensaje de éxito
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Usuario registrado correctamente')));

                          // Redirigir al usuario a la pantalla de inicio
                          Navigator.of(context).pop();
                        } on FirebaseAuthException catch (e) {
                          // Mostrar mensaje de error
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.message!)));
                        } finally {
                          setState(() {
                            _cargando = false;
                          });
                        }
                      }
                    },
                    child: const Text('Registrarse'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 40.0),
                    child: const Text(
                      "Dando click en 'Registrarse' estas aceptando nuestros términos y condiciones.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15.0),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

//Boton de retroceso
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

//Campo de entrada usuario
Widget _userName(BuildContext context, TextEditingController nombreController) {
  return Container(
    margin: const EdgeInsets.only(top: 40.0),
    decoration: BoxDecoration(
        color: bgEntradas, borderRadius: BorderRadius.circular(40.0)),
    child: TextFormField(
      controller: nombreController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          hintText: "Nombre",
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'El nombre no puede estar vacío';
        }
        return null;
      },
    ),
  );
}

Widget _lastName(
    BuildContext context, TextEditingController apellidoController) {
  return Container(
    margin: const EdgeInsets.only(top: 20.0),
    decoration: BoxDecoration(
        color: bgEntradas, borderRadius: BorderRadius.circular(40.0)),
    child: TextFormField(
      controller: apellidoController,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
          hintText: "Apellido",
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'El apellido no puede estar vacío';
        }
        return null;
      },
    ),
  );
}

//Campo de entrada email
Widget _emailTextfield(
    BuildContext context, TextEditingController emailController) {
  return Container(
    margin: const EdgeInsets.only(top: 20.0),
    decoration: BoxDecoration(
        color: bgEntradas, borderRadius: BorderRadius.circular(40.0)),
    child: TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
          hintText: "Correo electrónico",
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

//Campo de entrada numero de telefono
Widget _phoneTextfield(
    BuildContext context, TextEditingController numeroController) {
  return Container(
    margin: const EdgeInsets.only(top: 20.0),
    decoration: BoxDecoration(
        color: bgEntradas, borderRadius: BorderRadius.circular(40.0)),
    child: TextFormField(
      controller: numeroController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
          hintText: "Número de teléfono",
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'El numero de telefono no puede estar vacío';
        }
        return null;
      },
    ),
  );
}

//Campo de entrada password
Widget _passwordTextfield(
    BuildContext context, TextEditingController passwordController) {
  return Container(
    margin: const EdgeInsets.only(top: 20.0),
    decoration: BoxDecoration(
        color: bgEntradas, borderRadius: BorderRadius.circular(40.0)),
    child: TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      decoration: const InputDecoration(
          hintText: "Contraseña",
          border: OutlineInputBorder(borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'La contraseña no puede estar vacío';
        }
        return null;
      },
    ),
  );
}
