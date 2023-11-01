import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_conso/connexion/connexion.dart';
import 'package:flutter_conso/first_page.dart';
import 'package:flutter_conso/helpers/departement.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController departementController = TextEditingController();
  late String userEmail;
  Mongo.Db? db;

  late TextLabel? selectedDepartement;

  @override
  void initState() {
    super.initState();
    _initDb();
    selectedDepartement = TextLabel.ain;
  }

  Future<void> _initDb() async {
    db = await openMongoDB();
  }

  void createUser() async {
    final String email = emailController.text;
    final String password = passwordController.text;
    userEmail = emailController.text;

    final hashedPassword = await FlutterBcrypt.hashPw(
        password: password, salt: await FlutterBcrypt.salt());

    var db = await openMongoDB();

    try {
      await db.open();

      final userCollection = db.collection('users');

      final userDocument = {
        '_id': createObjectId(),
        'email': email,
        'password': hashedPassword,
        'residence': selectedDepartement?.code,
      };

      await userCollection.insertOne(userDocument);

      await db.close();
    } catch (e) {
      print('Erreur lors de la création du compte : $e');
    }
  }

  void dialog(BuildContext context, String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                    MyHomePage(title: 'Démo application flutter', userEmail: userEmail, db: db)
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<TextLabel>> departements =
        <DropdownMenuEntry<TextLabel>>[];
    for (final departement in TextLabel.values) {
      departements.add(DropdownMenuEntry<TextLabel>(
          value: departement, label: departement.label));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer un compte'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownMenu<TextLabel>(
              initialSelection: TextLabel.ain,
              controller: departementController,
              label: const Text('Département'),
              dropdownMenuEntries: departements,
              onSelected: (TextLabel? label) {
                setState(() {
                  selectedDepartement = label;
                });
              },
            ),
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
                createUser();
                dialog(context, 'Votre compte a été créé avec succès.',
                    'Compte créé');
              },
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
