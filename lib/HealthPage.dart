import 'package:cattle_mobile/SensorPage.dart';
import 'package:cattle_mobile/api/model/AnimalHealthModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key, required this.animalId, required this.id});
  final String id;
  final String animalId;

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  List<AnimalHealthModel>? animalHealthModel;

  @override
  void initState() {
    super.initState();
    fetchAnimalHealth();
  }

  Future<void> fetchAnimalHealth() async {
    try {
      final response = await Dio().get(
          'http://localhost:8081/api/v1/medical-history/${widget.animalId}');
      final List<dynamic> data = response.data;

      setState(() {
        animalHealthModel =
            data.map((json) => AnimalHealthModel.fromJson(json)).toList();
      });

      print('Animal health fetched successfully: $animalHealthModel');
    } catch (e) {
      print('Error fetching animal health: $e');
    }
  }

  Future<void> showAddAnimalHealthDialog() async {
    String id = '${widget.id}';
    String veterinarian = '';
    String diseaseName = '';
    String treatment = '';
    String diagnosisDate = '';
    String recoveryDate = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Sağlık Kaydı Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Veteriner'),
                onChanged: (value) => veterinarian = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Hastalık Adı'),
                onChanged: (value) => diseaseName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Tedavi'),
                onChanged: (value) => treatment = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Tanı Tarihi'),
                onChanged: (value) => diagnosisDate = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'İyileşme Tarihi'),
                onChanged: (value) => recoveryDate = value,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ekle'),
            onPressed: () async {
              try {
                await Dio().post(
                  'http://localhost:8081/api/v1/animal/add-medical-history',
                  data: {
                    "animalId": id,
                    "veterinarian": veterinarian,
                    "diseaseName": diseaseName,
                    "treatment": treatment,
                    "diagnosisDate": diagnosisDate,
                    "recoveryDate": recoveryDate
                  },
                );
                Navigator.of(context).pop();
                await fetchAnimalHealth();
              } catch (e) {
                print('Error adding animal health record: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Page'),
        centerTitle: true,
      ),
      body: animalHealthModel == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: animalHealthModel!.length,
              itemBuilder: (context, index) {
                final item = animalHealthModel![index];
                return Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      elevation: 2,
                      child: ListTile(
                        isThreeLine: true,
                        title: Text('Hayvan ID: ${item.animalId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Veteriner: ${item.veterinarian}'),
                            Text('Hastalık: ${item.diseaseName}'),
                            Text('Tedavi: ${item.treatment}'),
                            Text('Tanı: ${item.diagnosisDate}'),
                            Text('İyileşme: ${item.recoveryDate}'),
                          ],
                        ),
                        trailing: TextButton.icon(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text(
                            'Sil',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            try {
                              await Dio().delete(
                                'http://localhost:8081/api/v1/medical-history/${item.id}',
                              );
                              await fetchAnimalHealth();
                            } catch (e) {
                              print('Error deleting animal health record: $e');
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.sensors),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SensorPage(animalId: widget.animalId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: "Yeni Sağlık Kaydı Ekle",
        onPressed: showAddAnimalHealthDialog,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
