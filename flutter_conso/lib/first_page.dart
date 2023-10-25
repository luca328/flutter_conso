import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_conso/helpers/departement.dart';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> data = <dynamic>[]; //Stocker les données de l'API
  Set<String> displayedCommunes = <String>{};
  final TextEditingController departementController = TextEditingController();
  late TextLabel? selectedDepartement;

  @override
  void initState() {
    super.initState();
    selectedDepartement = TextLabel.ain;
    fetchDataFromAPI(); //Récupérez les données de l'API
  }

  Future<void> fetchDataFromAPI() async {
    final url = Uri.parse(
      'https://enedis.opendatasoft.com/api/explore/v2.1/catalog/datasets/consommation-annuelle-residentielle-par-adresse/records?select=nom_commune,consommation_annuelle_moyenne_de_la_commune_mwh&where=code_departement like \'${selectedDepartement?.code}\'&group_by=nom_commune,consommation_annuelle_moyenne_de_la_commune_mwh&limit=20000'
    );

    final response = await http.get(url);

    //test de récupération des données
    if (response.statusCode == 200) {
      final dynamic jsonData = json.decode(response.body);
      setState(() {
        print("jsondata: ${jsonData['results']} \n");
        data = jsonData['results'];
      });
    } else {
      print('Erreur lors de la récupération des données : ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<TextLabel>> departements = <DropdownMenuEntry<TextLabel>>[];
    for (final departement in TextLabel.values) {
      departements.add(DropdownMenuEntry<TextLabel>(
        value: departement,
        label: departement.label
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            DropdownMenu<TextLabel>(
              initialSelection: TextLabel.ain,
              controller: departementController,
              label: const Text('Département'),
              dropdownMenuEntries: departements,
              onSelected: (TextLabel? label){
                setState(() {
                  selectedDepartement = label;
                });
                fetchDataFromAPI();
              },
            ),
            Text('vous avez sélectionné : ${selectedDepartement?.label??TextLabel.ain.label}'),
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
      )
    );
  }
}
