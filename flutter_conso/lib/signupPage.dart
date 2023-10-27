import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
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

            const Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Lieu de résidence',
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                // Gérer la création de compte ici
              },
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
