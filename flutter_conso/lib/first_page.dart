import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> data = []; // Stocker les données de l'API

  @override
  void initState() {
    super.initState();
    fetchDataFromEnedisAPI(); // Appeler la fonction pour récupérer les données lors de l'initialisation
  }

  Future<void> fetchDataFromEnedisAPI() async {
    final url = Uri.parse(
      'https://enedis.opendatasoft.com/api/v2/catalog/datasets/consommation-annuelle-residentielle-par-adresse/records',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      // La requête a réussi. Analysez les données JSON.
      final jsonData = json.decode(response.body);
      setState(() {
        data = jsonData['records'];
      });
    } else {
      // Gérez les erreurs en cas d'échec de la requête.
      print('Erreur lors de la récupération des données : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(data[index]['record']['fields']['nom_commune']),
            subtitle: Text('Consommation : ${data[index]['record']['fields']['consommation_annuelle_moyenne_de_la_commune_mwh']} MWh'),
          );
        },
      ),
    );
  }
}
