// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:foodie/src/styles/button.dart';

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear un producto'),
      ),
      body: Form(
        child: ListView(children: [
          Column(children: [
            const SizedBox(height: 20),
            ElevatedButton(
              style: buttonPrimary,
              onPressed: () {
                Navigator.pushNamed(context, 'crearProductos');
              },
              child: const Text('Crear producto'),
            ),
          ]),
        ]),
      ),
    );
  }
}
