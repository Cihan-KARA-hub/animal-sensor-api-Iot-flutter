import 'package:cattle_mobile/api/model/AnimalHealthModel.dart';
import 'package:cattle_mobile/api/model/AnimalListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key, required Animal animal});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  List<AnimalHealthModel>? animalHealthModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> fetchAnimalHealth() async {
    try {
      final response =
          await Dio().get('http://10.196.157.99:8081/api/v1/animal/company/1');

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
                return ListTile(
                  //TODO : modellde sıkıntı var baştan düznelenecek
                  title: Text(animalHealthModel![index].animalId.toString()),
                  //subtitle: Text(animalHealthModel![index].healthStatus),
                  //trailing: Text(animalHealthModel![index].date.toString()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchAnimalHealth();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
