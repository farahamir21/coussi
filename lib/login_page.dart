import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'password_recovery_page.dart';
import 'database_helper.dart'; // Importez DatabaseHelper

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  // Fonction de connexion en utilisant DatabaseHelper
  void _login() async {
    setState(() {
      _errorMessage = '';
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Les champs ne doivent pas être vides';
      });
      return;
    }

    // Utiliser DatabaseHelper pour vérifier les informations de connexion
    final dbHelper = DatabaseHelper();
    final user = await dbHelper.loginUser(_emailController.text, _passwordController.text);

    if (user != null) {
      // Connexion réussie
      setState(() {
        _errorMessage = 'Connexion réussie !';
      });
    } else {
      // Connexion échouée
      setState(() {
        _errorMessage = 'Échec de la connexion. Vérifiez vos informations.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Arrière-plan avec image assombrie
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.darken,
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background_login.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Contenu de la page de connexion
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo en haut
                  Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Center(
                      child: Image.asset(
                        'assets/logo.png',
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Champ de texte Email
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey[800]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 2.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        // Champ de texte Password
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey[800]),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.orange, width: 2.0),
                            ),
                          ),
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        // Afficher le message d'erreur
                        if (_errorMessage.isNotEmpty)
                          Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: 20),
                        // Bouton de connexion
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text("Login", style: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(height: 10),
                        // Lien "Mot de passe oublié ?" centré en dessous de "Login"
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
                            );
                          },
                          child: Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(color: Colors.blue, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Texte "OR" et "Create new account"
                        Column(
                          children: [
                            Text(
                              "OR",
                              style: TextStyle(color: const Color.fromARGB(255, 230, 83, 5), fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpPage()),
                                );
                              },
                              child: Text(
                                "Create new account",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
