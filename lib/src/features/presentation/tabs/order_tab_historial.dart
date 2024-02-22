// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/AppBarWidget.dart';

// ... (import statements y otras declaraciones)
class OrdenHistorial extends StatefulWidget {
  const OrdenHistorial({super.key});

  @override
  _OrdenHistorialState createState() => _OrdenHistorialState();
}

class _OrdenHistorialState extends State<OrdenHistorial> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  List<Map<String, dynamic>> orders = [];

  double totalPrice = 0;

  Future<void> _getCurrentUser() async {
    user = _auth.currentUser;
    setState(() {});
  }

  Future<void> _getOrdersData() async {
    final databaseRef = FirebaseDatabase.instance.ref();
    final ordersRef = databaseRef.child("orders").child(user!.uid);

    final snapshot = await ordersRef.once();
    final data = snapshot.snapshot.value as Map<dynamic, dynamic>?;
    if (data != null) {
      final List<Map<String, dynamic>> ordersList = [];
      data.forEach((key, value) {
        final order = Map<String, dynamic>.from(value as dynamic);
        if (order['state'] == "entregado") {
          totalPrice += order['totalPrice'];
          ordersList.add({
            'key': key,
            'products': order['products'],
            'totalPrice': order['totalPrice'],
            'timestamp': order['timestamp'],
            'state': order['state'],
          });
        }
      });
      if (mounted) {
        setState(() {
          orders = ordersList;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          AppbarWidget(),
          Padding(
            padding: EdgeInsets.only(top: 0, left: 5, bottom: 5),
            child: Text(
              'Historial de ordenes',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Orden ${order['key']}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Fecha: ${DateTime.fromMicrosecondsSinceEpoch(order['timestamp']).toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Productos:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: order['products']
                              .map<Widget>(
                                (product) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${product['name']} - ${product['quantity']} unidades - ${product['price'].toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total: \$${order['totalPrice'].toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Estado: ${order['state']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Container(
              padding: EdgeInsets.all(20),
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
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: amarillo,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
