// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/AppBarWidget.dart';

class MenuSnacksGuest extends StatefulWidget {
  @override
  _MenuSnacksGuestState createState() => _MenuSnacksGuestState();
}

class _MenuSnacksGuestState extends State<MenuSnacksGuest> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String userEmail = "";
  String userName = "";

  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    user = _auth.currentUser;
    if (user != null) {
      await _getUserData();
    }
  }

  Future<void> _getUserData() async {
    if (user!.providerData
        .any((provider) => provider.providerId == 'google.com')) {
      _getGoogleUserData();
    } else {
      _getEmailPasswordUserData();
    }
  }

  Future<void> _getGoogleUserData() async {
    userName = user!.displayName ?? "";
    userEmail = user!.email ?? "";
  }

  Future<void> _getEmailPasswordUserData() async {
    final userData = await firestore.collection('Users').doc(user!.uid).get();
    if (userData.exists) {
      setState(() {
        userName = userData.get('name');
        userEmail = userData.get('email');
      });
    }
  }

  final DatabaseReference _databaseRef = database.ref();

  void enviarDatosRealtimeDatabase(String name, double price, String imgUrl) {
    final userRef = _databaseRef.child("carts").child(user!.uid);
    final productRef = userRef.child(name);

    userRef.child(name).get().then((snapshot) {
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

//** Mostrar el mensaje que asido agregado */
  void _showSnackbar(BuildContext context, String nombre) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Sea agregado $nombre al carrito',
          style: TextStyle(color: Colors.white),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: amarillo,
        duration: Duration(seconds: 2),
      ),
    );
  }

//** Agregar a favoritos */
  void addToFavorites(Product product) {
    final productRef =
        _databaseRef.child("favorites").child(user!.uid).child(product.name);

    productRef.set({
      DatabaseFields.nombre: product.name,
      DatabaseFields.precio: product.price,
      DatabaseFields.imagen: product.img,
    });
  }

//** NewestItemWidget
  Future<List<Widget>> _getNewetsItems() async {
    ProductService productService = ProductService();
    List<Product> products = await productService.getProducts(type: 'snacks');

    return products.map((product) {
      final nombre = product.name;
      final precio = product.price;
      final imagenUrl = product.img;
      // final descripcion = product.descripcion;

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: 380,
          height: 170,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                )
              ]),
          child: Row(children: [
            InkWell(
              onTap: () {
                // Navigator.pushNamed(context, 'itemPage');
              },
              child: Container(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  imageUrl: imagenUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                height: 120,
                width: 120,
              ),
            ),
            Container(
              width: 210,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      nombre,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    RatingBar.builder(
                      initialRating: 4,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 18,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) =>
                          Icon(Icons.star, color: amarillo),
                      onRatingUpdate: (index) {},
                    ),
                    Text(
                      "\$$precio",
                      style: TextStyle(
                        fontSize: 20,
                        color: amarillo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'perfilGuest');
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: amarillo,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'perfilGuest');
                    },
                    icon: Icon(
                      CupertinoIcons.cart,
                      color: amarillo,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
    }).toList();
  }
  //** NewestItemWidget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              AppbarWidget(),
              //** Buscador
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'search');
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 15,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Row(children: [
                        Icon(
                          CupertinoIcons.search,
                          color: Color.fromARGB(255, 243, 164, 16),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('Buscar...'),
                          ),
                        ),
                        // Icon(Icons.filter_list),
                      ]),
                    ),
                  ),
                ),
              ),
              //** Buscador

              //** Bebidas */
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Snacks",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
                ),
              ),
              FutureBuilder(
                future: _getNewetsItems(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Column(
                      children: snapshot.data!,
                    );
                  }
                },
              ),
              //** Mas */
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ]),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'perfilGuest');
          },
          child: Icon(
            CupertinoIcons.cart,
            size: 28,
            color: amarillo,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final String img;
  final String descripcion;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.img,
      required this.descripcion});

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['nombre'],
      price: data['precio'],
      img: data['imagen'],
      descripcion: data['descripcion'],
    );
  }
}

class ProductService {
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('productos');

  Future<List<Product>> getProducts({String type = ''}) async {
    QuerySnapshot querySnapshot =
        await productCollection.where('tipo', isEqualTo: type).get();
    return querySnapshot.docs
        .map((doc) =>
            Product.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}

class DatabaseFields {
  static const String nombre = "nombre";
  static const String precio = "precio";
  static const String imagen = "imagen";
}

void addToFavorites(String name, double price, String imgUrl) {
  User? user;

  final FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference _databaseRef = database.ref();

  final productRef =
      _databaseRef.child("favorites").child(user!.uid).child(name);

  productRef.set({
    DatabaseFields.nombre: name,
    DatabaseFields.precio: price,
    DatabaseFields.imagen: imgUrl,
  });
}
