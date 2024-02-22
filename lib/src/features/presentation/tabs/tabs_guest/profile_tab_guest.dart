// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie/auth_google.dart';
import 'package:foodie/src/styles/button.dart';

class PerfilUserGuest extends StatefulWidget {
  const PerfilUserGuest({super.key});

  @override
  State<PerfilUserGuest> createState() => _PerfilUserGuestState();
}

class _PerfilUserGuestState extends State<PerfilUserGuest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Form(
        child: ListView(children: [
          Column(children: [
            ElevatedButton(
              style: buttonPrimary,
              onPressed: () {
                Navigator.pushNamed(context, 'login');
              },
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: buttonSecondary,
              onPressed: () async {
                User? user = await Authenticator.iniciarSesion(context);
                print(user?.displayName);
                if (user != null) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, 'menu');
                }
              },
              icon: Image.asset('assets/google512px.png', scale: 25),
              label: const Text('Entrar con Google.'),
            ),
            const SizedBox(height: 20),
            // ElevatedButton(
            //   style: buttonPrimary,
            //   onPressed: () {
            //     Navigator.pushNamed(context, 'CrearProducto');
            //   },
            //   child: const Text('Crear producto'),
            // ),
          ]),
        ]),
      ),
    );
  }
}
