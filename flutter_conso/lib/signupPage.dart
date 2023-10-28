import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_conso/connexion/connexion.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();

  void createUser() async {

    final String email = emailController.text;
    final String password = passwordController.text;
    final String residence = residenceController.text;

    final hashedPassword = await FlutterBcrypt.hashPw(password: password, salt: await FlutterBcrypt.salt());

    var db = openMongoDB();

    try {
      await db.open();

      final userCollection = db.collection('utilisateurs');

      final userDocument = {
        'email': email,
        'password': hashedPassword,
        'residence': residence,
      };

      await userCollection.save(userDocument);

      await db.close();

      var context;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Compte créé'),
            content: const Text('Votre compte a été créé avec succès.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Erreur lors de la création du compte : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ),

            // Champ Lieu de Résidence
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: residenceController,
                decoration: const InputDecoration(
                  labelText: 'Lieu de résidence',
                ),
              ),
            ),

            // Bouton de Création de Compte
            ElevatedButton(
              onPressed: createUser,
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}