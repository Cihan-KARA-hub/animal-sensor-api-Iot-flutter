import 'package:cattle_mobile/HealthPage.dart';
import 'package:cattle_mobile/api/model/AnimalListModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
      final response =
          await Dio().get('http://10.192.2.188:8081/api/v1/animal/company/1');
      final List<dynamic> data = response.data;

      setState(() {
        animals = data.map((json) => Animal.fromJson(json)).toList();
      });
      print('Animals fetched successfully: $animals');
    } catch (e) {
      print('Error fetching animals: $e');
    }
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
                    trailing: Text(animals[index].birthDate.toString()),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthPage(
                            animal: animals[index],
                          ),
                        ),
                      );

                      print('Tapped on ${animals[index].tagId}');
                    },
                    leading: Icon(Icons.pets),
                  );
                },
              ),
      ),
    );
  }
}
