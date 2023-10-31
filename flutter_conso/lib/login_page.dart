import 'package:flutter/material.dart';
import 'package:flutter_conso/first_page.dart';
import 'package:flutter_conso/signup_page.dart';
import 'package:flutter_conso/connexion/connexion.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isAuthenticated = false;

  void loginUser() async {
    final db = await openMongoDB();
    final authentication = await checkUser(db ,emailController.text, passwordController.text);
    authentication ? setState((){isAuthenticated = true;}) : setState((){isAuthenticated = false;});
  }

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

            ElevatedButton(
              onPressed: () {
                if(isAuthenticated) {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Démo application flutter')),
                  );
                }
              },
              child: const Text('Connexion'),
            ),

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
