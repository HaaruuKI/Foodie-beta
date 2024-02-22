// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/styles/button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PerfilUser extends StatefulWidget {
  const PerfilUser({super.key});

  @override
  State<PerfilUser> createState() => _PerfilUserState();
}

class _PerfilUserState extends State<PerfilUser> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  String userEmail = "";
  String userName = "";

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      if (user!.providerData
          .any((provider) => provider.providerId == 'google.com')) {
        _getGoogleUserData();
      } else {
        _getEmailPasswordUserData();
      }
    }
  }

  Future<void> _getGoogleUserData() async {
    userName = user!.displayName ?? "";
    userEmail = user!.email ?? "";
  }

  Future<void> _getEmailPasswordUserData() async {
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();
    if (userData.exists) {
      setState(() {
        userName = userData.get('name');
        userEmail = userData.get('email');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                const SizedBox(height: 30),
                if (user != null)
                  Column(
                    children: [
                      Text(userName, style: const TextStyle(fontSize: 24)),
                      Text(userEmail, style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                // TextButton(
                //   onPressed: () {},
                //   child: const Text(
                //     'Configuraciones',
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),
                // ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'historial');
                  },
                  child: const Text(
                    'Historial de ordenes',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    style: buttonTertiary,
                    onPressed: () async {
                      await _auth.signOut();
                      await _googleSignIn.signOut();
                      Navigator.pushNamed(context, 'menu');
                    },
                    child: const Text("Cerrar sesion"),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
