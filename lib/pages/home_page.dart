import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/models/diario_model.dart';
import 'package:login/pages/usuarios_page.dart';
import 'package:provider/provider.dart';
import 'edit_diario_page.dart';
import 'add_diario.dart';
import '../controllers/user_controller.dart';

/// Exercício - Crie uma tela separada para listar os usuários.
/// -----> USANDO FUTURE BUILDER <-----
/// Destacar o usuário que está logado.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final userController = Provider.of<UserController>(
    context,
    listen: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            // FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            //   future: FirebaseFirestore.instance
            //       .collection('usuarios')
            //       .doc(userController.user!.uid)
            //       .get(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return DrawerHeader(
            //         child: Center(child: CircularProgressIndicator()),
            //       );
            //     }

            //     final user = UserModel.fromMap(snapshot.data!.data()!);

            //     return UserAccountsDrawerHeader(
            //       accountName: Text(user.nome),
            //       accountEmail: Text(userController.user!.email!),
            //     );
            //   },
            // ),
            UserAccountsDrawerHeader(
              accountName: Text(userController.model.nome),
              accountEmail: Text(userController.user!.email!),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Usuários"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListUsuariosPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await userController.logout();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('diarios')
            .where('ownerKey', isEqualTo: userController.user!.uid)
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditDiarioPage(
                        diario: diario,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDiario(),
            ),
          );
        },
      ),
    );
  }
}