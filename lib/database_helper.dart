import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern - une seule instance de DatabaseHelper est créée
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  // Constructeur interne
  DatabaseHelper._internal();

  // Variable pour stocker la base de données SQLite
  static Database? _database;

  // Accès à la base de données. La base de données est initialisée si elle n'est pas déjà ouverte
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialisation de la base de données
  Future<Database> _initDatabase() async {
    // Récupère le chemin vers le répertoire de stockage local de l'application
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'db.sqlite');

    // Vérifie si le fichier bd.sqlite existe déjà dans le répertoire local
    if (!await File(path).exists()) {
      // Copie bd.sqlite depuis les assets vers le répertoire local
          print("Copie de la base de données dans le stockage local");

      ByteData data = await rootBundle.load('assets/db.sqlite');
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    }else{    print("Base de données déjà existante dans le stockage local");
}

    // Ouvre la base de données
      print("Ouverture de la base de données : $path");

    return await openDatabase(path);
  }

  // Fonction pour enregistrer un nouvel utilisateur dans la base de données
  Future<int> registerUser(String firstName, String lastName, String email, String password) async {
    final db = await database;
    try {
      // Insère les données de l'utilisateur dans la table 'users'
      return await db.insert('users', {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      });
    } catch (e) {
      // Si l'email est déjà utilisé, retourne -1 pour indiquer une erreur
      return -1;
    }
  }

  // Fonction pour vérifier les informations de connexion de l'utilisateur
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await database;
    // Requête pour vérifier si un utilisateur avec cet email et mot de passe existe
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (result.isNotEmpty) {
      // Retourne les informations de l'utilisateur si elles existent
      return result.first;
    }
    // Retourne null si aucune correspondance trouvée
    return null;
  }

  // Nouvelle fonction pour obtenir tous les utilisateurs
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    // Retourne une liste de tous les utilisateurs de la table 'users'
    return await db.query('users');
  }
}
