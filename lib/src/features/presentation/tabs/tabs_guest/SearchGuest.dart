// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/AppBarWidget.dart';

class SearchGuest extends StatefulWidget {
  const SearchGuest({super.key});

  @override
  _SearchGuestState createState() => _SearchGuestState();
}

class _SearchGuestState extends State<SearchGuest> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _results = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          AppbarWidget(),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 30,
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
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Buscar...',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          _searchFirestore(text);
                        },
                      ),
                    ),
                  ),
                  // Icon(Icons.filter_list),
                ]),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, 'itemPageGuest',
                            arguments: {
                              'name': _results[index]['nombre'],
                              'price': _results[index]['precio'],
                              'img': _results[index]['imagen'],
                              'des': _results[index]['descripcion'],
                            });
                      },
                      child: ListTile(
                        title: Text(_results[index]['nombre']),
                        subtitle: Text('\$ ${_results[index]['precio']}'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _searchFirestore(String text) {
    String startAt = text;
    String endAt = '$text\uf8ff';

    FirebaseFirestore.instance
        .collection('productos')
        .where('nombre', isGreaterThanOrEqualTo: startAt)
        .where('nombre', isLessThanOrEqualTo: endAt)
        .get()
        .then((querySnapshot) {
      setState(() {
        _results = querySnapshot.docs;
      });
    });
  }
}





// // ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, library_private_types_in_public_api, file_names, sort_child_properties_last

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:foodie/src/colors/colors.dart';
// import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/AppBarWidget.dart';

// class Search extends StatefulWidget {
//   const Search({super.key});

//   @override
//   _SearchState createState() => _SearchState();
// }

// class _SearchState extends State<Search> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final TextEditingController _searchController = TextEditingController();
//   List<DocumentSnapshot> _results = [];
//   User? user;
//   String userEmail = "";
//   String userName = "";

//   static final FirebaseDatabase database = FirebaseDatabase.instance;
//   static final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUser();
//   }

//   Future<void> _getCurrentUser() async {
//     user = _auth.currentUser;
//     if (user != null) {
//       await _getUserData();
//     }
//   }

//   Future<void> _getUserData() async {
//     if (user!.providerData
//         .any((provider) => provider.providerId == 'google.com')) {
//       _getGoogleUserData();
//     } else {
//       _getEmailPasswordUserData();
//     }
//   }

//   Future<void> _getGoogleUserData() async {
//     userName = user!.displayName ?? "";
//     userEmail = user!.email ?? "";
//   }

//   Future<void> _getEmailPasswordUserData() async {
//     final userData = await firestore.collection('Users').doc(user!.uid).get();
//     if (userData.exists) {
//       setState(() {
//         userName = userData.get('name');
//         userEmail = userData.get('email');
//       });
//     }
//   }

//   final DatabaseReference _databaseRef = database.ref();

// //** Mostrar el mensaje que asido agregado */
//   void _showSnackbar(BuildContext context, String nombre) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'Sea agregado $nombre al carrito',
//           style: TextStyle(color: Colors.white),
//         ),
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: amarillo,
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }

// //** Agregar a favoritos */
//   void addToFavorites(String name, double price, String imgUrl) {
//     final productRef =
//         _databaseRef.child("favorites").child(user!.uid).child(name);

//     productRef.set({
//       "nombre": name,
//       "precio": price,
//       "imagen": imgUrl,
//     });
//   }

//   void enviarDatosRealtimeDatabase(String name, double price, String imgUrl) {
//     final userRef = _databaseRef.child("carts").child(user!.uid);
//     final productRef = userRef.child(name);

//     userRef.child(name).get().then((snapshot) {
//       if (snapshot.exists) {
//         // Producto ya existe, actualizar quantity
//         int existingQuantity = snapshot.child("quantity").value as int;
//         productRef.set({
//           "nombre": name,
//           "precio": price,
//           "imagen": imgUrl,
//           "quantity": existingQuantity + 1,
//         });
//       } else {
//         // Producto no existe, agregar nuevo
//         productRef.set({
//           "nombre": name,
//           "precio": price,
//           "imagen": imgUrl,
//           "quantity": 1,
//         });
//       }
//     });
//   }

// //** NewestItemWidget
//   Future<List<Widget>> _getNewetsItems() async {
//     final query = await firestore
//         .collection('productos')
//         .orderBy('precio')
//         .limit(10)
//         .get();

//     return query.docs.map((doc) {
//       final data = doc.data();
//       final nombre = data['nombre'];
//       final precio = data['precio'];
//       final imagenUrl = data['imagen'];

//       return Padding(
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: Container(
//           width: 380,
//           height: 170,
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 3,
//                   blurRadius: 10,
//                   offset: Offset(0, 3),
//                 )
//               ]),
//           child: Row(children: [
//             InkWell(
//               onTap: () {
//                 // Navigator.pushNamed(context, 'itemPage');
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 child: CachedNetworkImage(
//                   imageUrl: imagenUrl,
//                   placeholder: (context, url) => CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ),
//                 height: 120,
//                 width: 120,
//               ),
//             ),
//             Container(
//               width: 210,
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Text(
//                       nombre,
//                       style:
//                           TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),
//                     RatingBar.builder(
//                       initialRating: 4,
//                       minRating: 1,
//                       direction: Axis.horizontal,
//                       itemCount: 5,
//                       itemSize: 18,
//                       itemPadding: EdgeInsets.symmetric(horizontal: 4),
//                       itemBuilder: (context, _) =>
//                           Icon(Icons.star, color: amarillo),
//                       onRatingUpdate: (index) {},
//                     ),
//                     Text(
//                       "\$$precio",
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: amarillo,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ]),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       addToFavorites(nombre, precio, imagenUrl);
//                     },
//                     child: Icon(
//                       Icons.favorite_border,
//                       color: amarillo,
//                       size: 26,
//                     ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _showSnackbar(context, nombre);
//                       enviarDatosRealtimeDatabase(nombre, precio, imagenUrl);
//                     },
//                     child: Icon(
//                       CupertinoIcons.cart,
//                       color: amarillo,
//                       size: 26,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         ),
//       );
//     }).toList();
//   }
//   //** NewestItemWidget

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 30),
//           AppbarWidget(),
//           Padding(
//             padding: EdgeInsets.symmetric(
//               vertical: 30,
//               horizontal: 15,
//             ),
//             child: Container(
//               width: double.infinity,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 2,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: 10,
//                 ),
//                 child: Row(children: [
//                   Icon(
//                     CupertinoIcons.search,
//                     color: Color.fromARGB(255, 243, 164, 16),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Buscar...',
//                           border: InputBorder.none,
//                         ),
//                         onChanged: (text) {
//                           _searchFirestore(text);
//                         },
//                       ),
//                     ),
//                   ),
//                   // Icon(Icons.filter_list),
//                 ]),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _results.length,
//               itemBuilder: (context, index) {
//                 return Column(
//                   children: [
//                     FutureBuilder(
//                       future: _getNewetsItems(),
//                       builder: (BuildContext context,
//                           AsyncSnapshot<List<Widget>> snapshot) {
//                         if (snapshot.connectionState == ConnectionState.done) {
//                           return SingleChildScrollView(
//                               scrollDirection: Axis.horizontal,
//                               child: Column(
//                                 children: snapshot.data!,
//                               ));
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                     //** Mas */
//                     const SizedBox(height: 80),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _searchFirestore(String text) {
//     String startAt = text;
//     String endAt =
//         text + '\uf8ff'; // Se agrega '\uf8ff' para incluir la siguiente letra

//     FirebaseFirestore.instance
//         .collection('productos')
//         .where('nombre', isGreaterThanOrEqualTo: startAt)
//         .where('nombre', isLessThanOrEqualTo: endAt)
//         .get()
//         .then((querySnapshot) {
//       setState(() {
//         _results = querySnapshot.docs;
//       });
//     });
//   }
// }
