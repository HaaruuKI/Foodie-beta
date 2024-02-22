// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, sort_child_properties_last, library_private_types_in_public_api

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodie/src/colors/colors.dart';

class ExplorarTabGuest extends StatefulWidget {
  @override
  _ExplorarTabGuestState createState() => _ExplorarTabGuestState();
}

class _ExplorarTabGuestState extends State<ExplorarTabGuest> {
// ** PopularItemWidget
  Future<List<Widget>> document() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('productos');
    final query = await collection
        .orderBy('nombre')
        .limit(6) // Tomar solo los últimos 6 documentos
        .get();

    List<Widget> documentText = [];
    for (var doc in query.docs) {
      final data = doc.data();
      final nombre = data['nombre'];
      final precio = data['precio'];
      final imagenUrl = data['imagen'];
      documentText.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
          child: Row(children: [
            // Single Items
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 170,
                height: 250,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          // alignment: Alignment.center,
                          child: CachedNetworkImage(
                            imageUrl: imagenUrl,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          height: 130,
                        ),
                      ),
                      Text(
                        nombre,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$ $precio",
                            style: TextStyle(
                                fontSize: 17,
                                color: amarillo,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              child: Icon(Icons.favorite_border,
                                  color: amarillo, size: 26),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              child: Icon(CupertinoIcons.cart,
                                  color: amarillo, size: 26),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    }
    return documentText;
  }

// ** PopularItemWidget

  //** NewestItemWidget
  Future<List<Widget>> documentos() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('productos');
    final query = await collection.orderBy('precio').limit(10).get();
    List<Widget> documentText = [];
    for (var doc in query.docs) {
      final data = doc.data();
      final nombre = data['nombre'];
      final precio = data['precio'];
      final imagenUrl = data['imagen'];
      documentText.add(
        Padding(
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
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
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
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.favorite_border,
                        color: amarillo,
                        size: 26,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
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
        ),
      );
    }
    return documentText;
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
              //** Buscador
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 50,
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
                      ]),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(children: [
                      Icon(
                        CupertinoIcons.search,
                        color: Color.fromARGB(255, 243, 164, 16),
                      ),
                      Container(
                        height: 50,
                        width: 280,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Buscar...",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      // Icon(Icons.filter_list),
                    ]),
                  ),
                ),
              ),
              //** Buscador

              //** Catecorias */
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  'Categoria',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              // CategoriasWidget(),
              //** PopularesItemWidget
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Populares",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              FutureBuilder(
                future: document(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: snapshot.data!,
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              //** PopularesItemWidget

              //** Mas */
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  "Mas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ),
              FutureBuilder(
                future: documentos(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Widget>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: snapshot.data!,
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              //** Mas */
              const SizedBox(height: 70),
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
            Navigator.pushNamed(context, 'cartPage');
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
