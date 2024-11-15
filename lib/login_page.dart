import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'password_recovery_page.dart';
import 'database_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';
  String _successMessage = '';

  // Fonction de connexion en utilisant DatabaseHelper
  void _login() async {
    setState(() {
      _errorMessage = '';
      _successMessage = '';
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Les champs ne doivent pas être vides';
      });
      return;
    }

    final dbHelper = DatabaseHelper();
    final user = await dbHelper.loginUser(_emailController.text, _passwordController.text);

    if (user != null) {
      setState(() {
        _successMessage = 'Connexion réussie !';
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Échec de la connexion. Vérifiez vos informations.';
        _successMessage = '';
      });
    }
  }

  // Fonction pour afficher tous les utilisateurs
  void _showAllUsers() async {
    final dbHelper = DatabaseHelper();
    final users = await dbHelper.getAllUsers();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tous les utilisateurs"),
          content: users.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: users.map((user) {
                    return ListTile(
                      title: Text(user['firstName'] + " " + user['lastName']),
                      subtitle: Text(user['email']),
                    );
                  }).toList(),
                )
              : Text("Aucun utilisateur trouvé."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                          height: 290,
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
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autocorrect: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              hintText: "Email",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.orange, width: 1.5),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                              hintText: "Password",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.orange, width: 1.5),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 10),
                          if (_errorMessage.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Text(
                                _errorMessage,
                                style: TextStyle(color: Colors.red, fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          if (_successMessage.isNotEmpty)
                            Text(
                              _successMessage,
                              style: TextStyle(color: Colors.green, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                              width: 150, // Largeur plus petite pour le bouton "Login"
                              child: ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                child: Text("Login", style: TextStyle(fontSize: 18)),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PasswordRecoveryPage()),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Mot de passe oublié ?",
                                style: TextStyle(color: Colors.blue[900], fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: _showAllUsers,
                            child: Text(
                              "Afficher tous les utilisateurs",
                              style: TextStyle(color: Colors.blue, fontSize: 14),
                            ),
                          ),
                          SizedBox(height: 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center,
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
                                  textAlign: TextAlign.center,
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
      ),
    );
  }
}
