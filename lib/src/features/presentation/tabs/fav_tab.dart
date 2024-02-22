// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';

// ... (import statements y otras declaraciones)
class Favoritos extends StatefulWidget {
  const Favoritos({super.key});

  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getCartData();
  }

  Future<void> _getCurrentUser() async {
    user = _auth.currentUser;
    setState(() {});
  }

  Future<void> _getCartData() async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final cartRef = databaseRef.child("favorites").child(user!.uid);

    final snapshot = await cartRef.once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      final List<Map<String, dynamic>> items = [];
      data.forEach((key, value) {
        final product = Map<String, dynamic>.from(value as dynamic);
        items.add({
          'key': key,
          'name': product['nombre'],
          'price': product['precio'],
          'img': product['imagen'],
        });
      });
      if (mounted) {
        setState(() {
          this.items = items;
        });
      }
    }

    // Listen for data changes
    cartRef.onValue.listen((event) {
      final snapshot = event.snapshot;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        final List<Map<String, dynamic>> items = [];
        data.forEach((key, value) {
          final product = Map<String, dynamic>.from(value as dynamic);
          items.add({
            'key': key,
            'name': product['nombre'],
            'price': product['precio'],
            'img': product['imagen'],
          });
        });
        if (mounted) {
          setState(() {
            this.items = items;
          });
        }
      }
    });
  }

  Future<void> _deleteCart() async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final cartRef = databaseRef.child("favorites").child(user!.uid);
    await cartRef.remove();
  }

  //** SnackBar
  void _showSnackbar(BuildContext context, String nombre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sea agregado $nombre al carrito',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: amarillo,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void enviarDatosRealtimeDatabase(String name, double price, String imgUrl) {
    final databaseRef = FirebaseDatabase.instance.ref();
    final userRef = databaseRef.child("carts").child(user!.uid);
    final productRef = userRef.child(name);

    databaseRef
        .child("carts")
        .child(user!.uid)
        .child(name)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        // Producto ya existe, actualizar quantity
        int existingQuantity = snapshot.child("quantity").value as int;
        productRef.set({
          "nombre": name,
          "precio": price,
          "imagen": imgUrl,
          "quantity": existingQuantity + 1,
        });
      } else {
        // Producto no existe, agregar nuevo
        productRef.set({
          "nombre": name,
          "precio": price,
          "imagen": imgUrl,
          "quantity": 1,
        });
      }
    });
  }

  String nombre = "";
  double precio = 0;
  String imagenUrl = "";

  //** SnackBar

  //** Borrar producto agregado a favorito
  Future<void> _deleteItem(String itemKey) async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final cartRef = databaseRef.child("favorites").child(user!.uid);
    await cartRef.child(itemKey).remove();
  }
  //** Borrar producto agregado a favorito

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Padding(
            padding: EdgeInsets.only(top: 0, left: 5, bottom: 5),
            child: Text(
              'Favoritos',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                    title: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 9),
                          child: Container(
                            width: 400,
                            height: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ]),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.network(
                                    item['img'],
                                    width: 130,
                                    height: 80,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '\$${item['price'].toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: amarillo,
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          await _deleteItem(item['key']);
                                          _getCartData();
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: amarillo,
                                          size: 26,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _showSnackbar(context, nombre);
                                          enviarDatosRealtimeDatabase(
                                              nombre, precio, imagenUrl);
                                        },
                                        icon: Icon(
                                          CupertinoIcons.cart,
                                          color: amarillo,
                                          size: 26,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]));
              },
            ),
          ),
        ],
      ),
    );
  }
}
