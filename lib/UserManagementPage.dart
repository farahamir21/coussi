import 'package:flutter/material.dart';
import 'database_helper.dart';

// Déclaration de la page UserManagementPage 
class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

// Classe d'état associée à UserManagementPage
class _UserManagementPageState extends State<UserManagementPage> {
  // Liste pour stocker les utilisateurs récupérés depuis la base de données
  List<Map<String, dynamic>> _users = [];

  // Méthode qui est appelée lors de l'initialisation de l'état
  @override
  void initState() {
    super.initState();
    _loadUsers(); // Charger les utilisateurs dès l'ouverture de la page
  }

  // Fonction asynchrone pour charger les utilisateurs depuis la base de données
  Future<void> _loadUsers() async {
    // Récupère la liste des utilisateurs depuis DatabaseHelper
    final users = await DatabaseHelper().getAllUsers();
    // Met à jour l'état avec la liste des utilisateurs récupérés
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'), // Titre de l'application dans la barre d'app
      ),
      // Corps de la page qui affiche la liste des utilisateurs
      body: ListView.builder(
        itemCount: _users.length, // Nombre d'éléments dans la liste
        itemBuilder: (context, index) {
          // Récupère l'utilisateur à l'index actuel
          final user = _users[index];
          // Affiche les informations de l'utilisateur dans une ListTile
          return ListTile(
            title: Text('${user['firstName']} ${user['lastName']}'), // Affiche le nom complet
            subtitle: Text(user['email']), // Affiche l'email en sous-titre
          );
        },
      ),
    );
  }
}
