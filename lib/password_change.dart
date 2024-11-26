import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PasswordChangePage extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Méthode pour vérifier le code et changer le mot de passe
Future<void> verifyCodeAndChangePassword(BuildContext context) async {
  final email = 'farah21.amir@gmail.com'; // Récupérez dynamiquement si possible
  final code = _codeController.text.trim();
  final newPassword = _newPasswordController.text.trim();

  if (email.isEmpty || code.isEmpty || newPassword.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Tous les champs sont requis.")),
    );
    return;
  }

  final url = Uri.parse('http://10.0.2.2/MY_API/verify_code_and_change_password.php');

  try {
    final response = await http.post(
      url,
      body: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );

    final data = json.decode(response.body);

    if (data['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Retour à la page précédente
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message']), backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erreur lors de la connexion au serveur.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Changer le mot de passe"),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de texte pour le code
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: "Code",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Champ de texte pour le nouveau mot de passe
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Nouveau mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            // Champ de texte pour confirmer le mot de passe
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirmer le mot de passe",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Bouton de validation
            ElevatedButton(
              onPressed: () => verifyCodeAndChangePassword(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: Colors.orange,
              ),
              child: Text(
                "Valider",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
