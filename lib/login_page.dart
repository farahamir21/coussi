import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import pour les requêtes HTTP
import 'dart:convert'; // Pour décoder les réponses JSON
import 'home_page.dart';
import 'sign_up_page.dart';
import 'password_recovery_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Définition de la clé du formulaire
  String _errorMessage = '';
  String _successMessage = '';

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
      _successMessage = '';
    });

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Les champs ne doivent pas être vides.';
      });
      return;
    }

    var body = {
      'action': 'login',
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/MY_API/users.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          setState(() {
            _successMessage = 'Connexion réussie !';
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          setState(() {
            _errorMessage = data['message'];
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Erreur serveur (${response.statusCode}), réessayez plus tard.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur est survenue : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
            SingleChildScrollView(
              child: Form(
                key: _formKey, // Correction ici
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                              width: 150,
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
