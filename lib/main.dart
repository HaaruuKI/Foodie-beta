import 'package:flutter/material.dart';
import 'package:foodie/src/colors/colors.dart';
import 'package:foodie/src/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
// TODO: Para Web

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB3HaUw7-mpm3C5ECkfJdwtQe9HcQrlyLU",
        authDomain: "foodiee-48042.firebaseapp.com",
        databaseURL: "https://foodiee-48042-default-rtdb.firebaseio.com",
        projectId: "foodiee-48042",
        storageBucket: "foodiee-48042.appspot.com",
        messagingSenderId: "361906893942",
        appId: "1:361906893942:web:2b0b813bc63f02dd7a1b57",
        measurementId: "G-PJ1P0NTFDT"),
  );
  runApp(const MyApp());
}

// TODO: Para android
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute: 'bienvenida',
        theme: ThemeData(
            primaryColor: amarillo,
            disabledColor: gris,
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            appBarTheme: const AppBarTheme(
                iconTheme:
                    IconThemeData(color: Color.fromARGB(255, 255, 255, 255))),
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color.fromARGB(255, 243, 164, 16))));
  }
}

// TODO: Crear Producto

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(
//         apiKey: "AIzaSyB3HaUw7-mpm3C5ECkfJdwtQe9HcQrlyLU",
//         authDomain: "foodiee-48042.firebaseapp.com",
//         databaseURL: "https://foodiee-48042-default-rtdb.firebaseio.com",
//         projectId: "foodiee-48042",
//         storageBucket: "foodiee-48042.appspot.com",
//         messagingSenderId: "361906893942",
//         appId: "1:361906893942:web:2b0b813bc63f02dd7a1b57",
//         measurementId: "G-PJ1P0NTFDT"),
//   );
//   runApp(const MyApp());
// }

// TODO: Para android
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         routes: routes,
//         initialRoute: 'bienvenida',
//         theme: ThemeData(
//             primaryColor: amarillo,
//             disabledColor: gris,
//             scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//             appBarTheme: const AppBarTheme(
//                 iconTheme:
//                     IconThemeData(color: Color.fromARGB(255, 255, 255, 255))),
//             colorScheme: ColorScheme.fromSwatch()
//                 .copyWith(secondary: const Color.fromARGB(255, 243, 164, 16))));
//   }
// }
