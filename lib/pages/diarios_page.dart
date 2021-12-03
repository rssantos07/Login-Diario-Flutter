import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/controllers/user_controller.dart';
import 'package:login/models/diario_model.dart';
import 'package:provider/provider.dart';

import 'edit_diario_page.dart';

class DiariosPage extends StatefulWidget {
  @override
  _DiariosPageState createState() => _DiariosPageState();
}

class _DiariosPageState extends State<DiariosPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diários'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('diarios')
            .orderBy('titulo')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final diarios = snapshot.data!.docs.map((map) {
            final data = map.data();
            return DiarioModel.fromMap(data, map.id);
          }).toList();

          return ListView.builder(
            itemCount: diarios.length,
            itemBuilder: (context, index) {
              final diario = diarios[index];
              return ListTile(
                title: Text(diario.titulo),
                subtitle: Row(
                  children: [
                    Icon(Icons.location_on),
                    Text(diario.local),
                     Icon(Icons.person),
                     Text(diario.autor),

                  ],
                ),
                leading: diario.imagem != null
                    ? Image.memory(
                        diario.imagem!,
                        fit: BoxFit.cover,
                        width: 72,
                      )
                    : Container(
                        child: Icon(Icons.location_on),
                        width: 72,
                        height: double.maxFinite,
                        color: Colors.blue,
                      ),
                onTap: () {
                   
                },
              );
            },
          );
        },
      ),
    );
  }
}
