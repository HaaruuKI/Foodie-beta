import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodie/src/features/presentation/tabs/explore_tab.dart';
import 'package:foodie/src/features/presentation/tabs/profile_tab.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_guest/explore_tab_guest.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_guest/profile_tab_guest.dart';
//Importando las 'Pages' tab.
import 'fav_tab.dart';
import 'order_tab.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  //Arreglo de objetos.
  final List<Widget> _widgetOptions = [
    ExplorarTab(),
    const MiOrden(),
    Favoritos(),
    const PerfilUser(),
  ];

  final List<Widget> _widgetOptionsGuest = [
    ExplorarTabGuest(),
    const PerfilUserGuest()
  ];

  //declaracion variable tipo entero para jugar con los indices del arreglo.
  int _selectedItem = 0;
  int _selectedItemGuest = 0;

  // Obtén el usuario actual
  void _cambioWidgetGuest(int index) {
    setState(() {
      _selectedItemGuest = index;
    });
  }

  void _cambioWidget(int index) {
    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user;
    try {
      user = FirebaseAuth.instance.currentUser;
    } on FirebaseException {
      return Scaffold(
        body: _widgetOptions.elementAt(_selectedItemGuest),
        bottomNavigationBar: _bottomNavBar(context),
      );
    }

    if (user != null) {
      return Scaffold(
        body: _widgetOptions.elementAt(_selectedItem),
        bottomNavigationBar: _bottomNavBar(context),
      );
    } else {
      return Scaffold(
        body: _widgetOptionsGuest.elementAt(_selectedItemGuest),
        bottomNavigationBar: _bottomNavBarGuest(context),
      );
    }
  }

  Widget _bottomNavBarGuest(BuildContext context) {
    return BottomNavigationBar(
        iconSize: 30.0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItemGuest,
        onTap: _cambioWidgetGuest,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_rounded),
            label: 'Menú  ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Perfil',
          ),
        ]);
  }

  Widget _bottomNavBar(BuildContext context) {
    return BottomNavigationBar(
        iconSize: 30.0,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedItem,
        onTap: _cambioWidget,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_rounded),
            label: 'Menú  ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_rounded),
            label: 'Mi orden',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_rounded),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Perfil',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.account_circle_outlined),
          //   label: 'Pruebas',
          // ),
        ]);
  }
}
