import 'package:flutter/material.dart';
import 'package:flutter_conso/connexion/connexion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_conso/helpers/departement.dart';
import 'package:mongo_dart/mongo_dart.dart' as Mongo;


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.userEmail, required this.db}) : super(key: key);
  final String userEmail;
  final String title;
  final Mongo.Db? db;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> data = <dynamic>[];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final selectedDepartement = getResidence(widget.db, widget.userEmail);
    final url = Uri.parse(
      'https://enedis.opendatasoft.com/api/explore/v2.1/catalog/datasets/consommation-annuelle-residentielle-par-adresse/records?select=nom_commune,consommation_annuelle_moyenne_de_la_commune_mwh&where=code_departement like \'${selectedDepartement?.code}\'&group_by=nom_commune,consommation_annuelle_moyenne_de_la_commune_mwh&limit=20000'
    );

    final response = await http.get(url);

    //test de récupération des données
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      setState(() {
        data = jsonData['results'];
      });
    } else {
      print('Erreur lors de la récupération des données : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Text('Consommation annuelle par commune :'),
          Flexible(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final commune = data[index]['nom_commune'];
                return ListTile(
                  key: UniqueKey(),
                  title: Text(commune),
                  subtitle: Text('Consommation : ${data[index]['consommation_annuelle_moyenne_de_la_commune_mwh']} MWh'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}