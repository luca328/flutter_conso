import 'package:flutter/material.dart';
import 'package:flutter_conso/first_page.dart';
import 'package:flutter_conso/signup_page.dart';
import 'package:flutter_conso/connexion/connexion.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late String userEmail;
  bool isAuthenticated = false;
  Mongo.Db? db;

  @override
  void initState() {
    super.initState();
    _initDb();  
  }

  Future<void> _initDb() async {
    db = await openMongoDB();
  }

  Future<bool> loginUser() async {
    userEmail = emailController.text;
    final result = await checkUser(db, emailController.text, passwordController.text);
    await db?.close();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    void navigate() {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyHomePage(title: 'Démo application flutter', userEmail: userEmail, db: db,)),);
    }
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
              onPressed: () async {
                final isAuthenticated = await loginUser();
                if(isAuthenticated) {
                  navigate();
                }
              },
              child: const Text('Connexion'),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
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