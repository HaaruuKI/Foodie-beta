import 'package:flutter/material.dart';
import 'package:foodie/crear_producto/crear_productos.dart';
import 'package:foodie/crear_producto/principal.dart';
//Pantallas
import 'package:foodie/src/features/presentation/bienvenida/View/bienvenida_pantalla.dart';
import 'package:foodie/src/features/presentation/cart_store/CartPage.dart';
import 'package:foodie/src/features/presentation/login/View/login_page.dart';
import 'package:foodie/src/features/presentation/menu/menu_comidas.dart';
import 'package:foodie/src/features/presentation/menu/menu_bebidas.dart';
import 'package:foodie/src/features/presentation/menu/menu_guest/menu_bebidas_guest.dart';
import 'package:foodie/src/features/presentation/menu/menu_guest/menu_comidas_guest.dart';
import 'package:foodie/src/features/presentation/menu/menu_guest/menu_snacks_guest.dart';
import 'package:foodie/src/features/presentation/menu/menu_guest/menu_temporada_guest.dart';
import 'package:foodie/src/features/presentation/menu/menu_snacks.dart';
import 'package:foodie/src/features/presentation/menu/menu_temporada.dart';
import 'package:foodie/src/features/presentation/recuperarpass/View/recuperarpass.dart';
import 'package:foodie/src/features/presentation/recuperarpass/View/pass_google_or_foodie.dart';
import 'package:foodie/src/features/presentation/tabs/order_tab_historial.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_guest/ItemPageGuest.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_guest/SearchGuest.dart';
// import 'package:foodie/src/features/presentation/tabs/tabs_guest/ItemPage.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_guest/profile_tab_guest.dart';
import 'package:foodie/src/features/presentation/registrarse/View/crearcuenta_page.dart';
import 'package:foodie/src/features/presentation/tabs/tabs_page.dart';
import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/ItemPage.dart';
import 'package:foodie/src/features/presentation/tabs/widget_explorar_tab/Search.dart';

/// Rutas de la aplicación
final routes = <String, WidgetBuilder>{
  // Rutas de autenticación
  'bienvenida': (BuildContext context) => const SplashScreen(),
  'login': (BuildContext context) => const LoginPage(),
  'GoogleOrFoodie': (BuildContext context) => const PassGoogleOrFoodie(),
  'forpass': (BuildContext context) => const RecuperarPass(),
  'registrarse': (BuildContext context) => const SignUp(),

  // Rutas de menú
  'menu': (BuildContext context) => const TabsPage(),
  'Comidas': (BuildContext context) => MenuComida(),
  'Bebidas': (BuildContext context) => MenuBebida(),
  'Snacks': (BuildContext context) => MenuSnacks(),
  'Temporada': (BuildContext context) => MenuTemporada(),

  // Rutas de menú guest
  'ComidasGuest': (BuildContext context) => MenuComidaGuest(),
  'BebidasGuest': (BuildContext context) => MenuBebidaGuest(),
  'SnacksGuest': (BuildContext context) => MenuSnacksGuest(),
  'TemporadaGuest': (BuildContext context) => MenuTemporadaGuest(),

  // Rutas de perfil
  'perfilLogin': (BuildContext context) => const PerfilUserGuest(),

  // Rutas de creación de productos
  'principal': (BuildContext context) => const Principal(),
  'crearProductos': (BuildContext context) => const CrearProducto(),

  // Ruta para compras
  'cartPage': (BuildContext context) => const CartPage(),

  // Ruta de PerfilUserGuest
  'perfilGuest': (BuildContext context) => const PerfilUserGuest(),

  // Ruta para search.dart
  'search': (BuildContext context) => const Search(),

  // Ruta para seachGuest
  'searchGuest': (BuildContext context) => const SearchGuest(),

  // Ruta para Producto
  'itemPage': (BuildContext context) => ItemPage(),

  //ruta Para producto guest
  'itemPageGuest': (BuildContext context) => ItemPageGuest(),

  // Ruta de Historial de Ordenes
  'historial': (BuildContext context) => const OrdenHistorial(),
};
