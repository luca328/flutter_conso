import 'package:flutter/material.dart';
import 'package:flutter_conso/signupPage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Champ Email
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                ),
                obscureText: true,
              ),
            ),


            ElevatedButton(
              onPressed: () {
                // Gérer la connexion ici
              },
              child: Text('Connexion'),
            ),

            // Lien vers la création de compte
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupPage()),
                );
              },
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
