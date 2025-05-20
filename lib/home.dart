import 'package:cattle_mobile/HealthPage.dart';
import 'package:cattle_mobile/api/model/AnimalListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.companyId}) : super(key: key);
  final String companyId;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Animal> animals = [];

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  Future<void> fetchAnimals() async {
    try {
      final String companyId = widget.companyId;

      final response = await Dio()
          .get('http://localhost:8081/api/v1/animal/company/$companyId');
      final List<dynamic> data = response.data;

      setState(() {
        animals = data.map((json) => Animal.fromJson(json)).toList();
      });
      print('Animals fetched successfully: $animals');
    } catch (e) {
      print('Error fetching animals: $e');
    }
  }

  Future<void> deleteAnimal(String id) async {
    try {
      await Dio().delete('http://localhost:8081/api/v1/animal/$id');
      fetchAnimals(); // yeniden listeyi getir
    } catch (e) {
      print('Error deleting animal: $e');
    }
  }

  void showAddAnimalDialog() {
    String tagId = '';
    String species = '';
    String birthDate = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni Hayvan Ekle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Tag ID'),
              onChanged: (value) => tagId = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tür'),
              onChanged: (value) => species = value,
            ),
            TextField(
              decoration:
                  InputDecoration(labelText: 'Doğum Tarihi (YYYY-MM-DD)'),
              onChanged: (value) => birthDate = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Dio().post(
                  'http://localhost:8081/api/v1/animal',
                  data: {
                    "tagId": tagId,
                    "company": int.parse(widget.companyId),
                    "species": species,
                    "birthDate": birthDate
                  },
                );
                fetchAnimals();
              } catch (e) {
                print('Error adding animal: $e');
              }
            },
            child: Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void showUpdateAnimalDialog(Animal animal) {
    String species = animal.species;
    String birthDate = animal.birthDate.toIso8601String().split('T')[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hayvan Güncelle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: species),
              decoration: InputDecoration(labelText: 'Tür'),
              onChanged: (value) => species = value,
            ),
            TextField(
              controller: TextEditingController(text: birthDate),
              decoration: InputDecoration(labelText: 'Doğum Tarihi'),
              onChanged: (value) => birthDate = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Dio().put(
                  'http://localhost:8081/api/v1/animal/${animal}',
                  data: {
                    "tagId": animal.tagId,
                    "company": animal.company,
                    "species": species,
                    "birthDate": birthDate
                  },
                );
                fetchAnimals();
              } catch (e) {
                print('Error updating animal: $e');
              }
            },
            child: Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Farm Animals"),
          centerTitle: true,
        ),
        body: animals.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: animals.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(animals[index].tagId),
                    subtitle: Text(animals[index].species),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'update') {
                          showUpdateAnimalDialog(animals[index]);
                        } else if (value == 'delete') {
                          deleteAnimal(animals[index].id.toString());
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'update',
                          child: Text('Güncelle'),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text('Sil'),
                        ),
                      ],
                    ),
                    leading: Icon(Icons.pets),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthPage(
                            animalId: animals[index].tagId,
                            id: animals[index].id.toString(),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: showAddAnimalDialog,
          child: Icon(Icons.add),
          tooltip: "Yeni Hayvan Ekle",
        ),
      ),
    );
  }
}
