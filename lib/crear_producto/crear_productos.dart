import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearProducto extends StatefulWidget {
  const CrearProducto({super.key});

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  File? imagen_to_upload;
  TextEditingController nombreController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  children: [
                    TextField(
                      controller: nombreController,
                      decoration: InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: tipoController,
                      decoration: InputDecoration(labelText: 'Categoria'),
                    ),
                    TextField(
                      controller: precioController,
                      decoration: InputDecoration(labelText: 'Precio'),
                    ),
                    TextField(
                      controller: descripcionController,
                      decoration: InputDecoration(labelText: 'Descripcion'),
                    ),
                  ],
                ),
              ),
              // imagen_to_upload != null
              //     ? Image.file(imagen_to_upload!)
              //     : Container(
              //         margin: const EdgeInsets.all(10),
              //         height: 200,
              //         width: double.infinity,
              //         color: Colors.red,
              //       ),
              ElevatedButton(
                onPressed: () async {
                  final XFile? imagen = await getImage();
                  setState(() {
                    imagen_to_upload = File(imagen!.path);
                  });
                },
                child: const Text('Selecionar iamgen'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imagen_to_upload == null) {
                    return;
                  }
                  final uploaded = await uploadData(
                    imagen_to_upload!,
                    nombreController.text,
                    tipoController.text,
                    precioController.text,
                    descripcionController.text,
                  );
                  if (uploaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Datos subidos')));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Error al subir los datos')));
                  }
                },
                child: const Text('Subir datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image;
}

final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<bool> uploadData(File image, String nombre, String tipo, String precio,
    String descripcion) async {
  try {
    final String namefile = image.path.split('/').last;

    final Reference ref = storage.ref().child('imagen').child(namefile);

    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    if (snapshot.state == TaskState.success) {
      final imageUrl = await ref.getDownloadURL();
      await firestore.collection('prod').doc(nombre).set({
        'nombre': nombre,
        'tipo': tipo,
        'precio': precio,
        'url': imageUrl,
        'descripcion': descripcion,
      });
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
