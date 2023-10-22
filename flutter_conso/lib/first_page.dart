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
  late List<dynamic> data = []; //Stocker les données de l'API
  Set<String> displayedCommunes = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI(); //Récupérez les données de l'API
  }

  Future<void> fetchDataFromAPI() async {
    final url = Uri.parse(
      'https://enedis.opendatasoft.com/api/v2/catalog/datasets/consommation-annuelle-residentielle-par-adresse/records',
    );

    final response = await http.get(url);

    //test de récupération des données
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        data = jsonData['records'];
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
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
           final commune = data[index]['record']['fields']['nom_commune'];
          if (!displayedCommunes.contains(commune)) {
            displayedCommunes.add(commune);
            return ListTile(
              title: Text(commune),
              subtitle: Text('Consommation : ${data[index]['record']['fields']['consommation_annuelle_moyenne_de_la_commune_mwh']} MWh'),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
