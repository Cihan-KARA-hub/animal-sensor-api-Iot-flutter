import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key, required this.animalId});
  final String animalId;

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  Map<String, dynamic>? data;
  int currentPage = 0;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchSensorData(currentPage);
  }

  Future<void> fetchSensorData(int page) async {
    String animalId = widget.animalId;
    if (animalId.isEmpty) {
      print('Animal ID is empty');
      return;
    }
    try {
      // id tag geliyor
      print('Fetching data for page: ${widget.animalId}, page: $page');
      final response = await Dio().get(
        'http://localhost:8081/api/v1/animal-health/get-sensor/${widget.animalId}?page=$page&size=15',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }),
      );

      setState(() {
        data = response.data;
        currentPage = data!['currentPage'] ?? 0;
        totalPages = data!['totalPages'] ?? 1;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Widget sectionCard(
      String title, List<double> values, List<String> timestamps, String unit) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: values
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      color: Colors.blue,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlue],
                      ),
                      belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.3),
                              Colors.transparent
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 32,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < timestamps.length) {
                            final dt = DateTime.parse(timestamps[index]);
                            return Text(
                              DateFormat.Hm().format(dt),
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 100,
                        getTitlesWidget: (value, _) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(),
                      bottom: BorderSide(),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                unit,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Sayfa: ${currentPage + 1} / $totalPages',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
                      ? () => fetchSensorData(currentPage - 1)
                      : null,
                  child: const Text('⬅️ Önceki'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: currentPage < totalPages - 1
                      ? () => fetchSensorData(currentPage + 1)
                      : null,
                  child: const Text('Sonraki ➡️'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final heartBeats =
        List<Map<String, dynamic>>.from(data!['heartBeats'] ?? []);
    final temps =
        List<Map<String, dynamic>>.from(data!['temperatureHumidities'] ?? []);
    final chews =
        List<Map<String, dynamic>>.from(data!['chewingActivities'] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text('Canlı Sensör Verisi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            sectionCard(
              '❤️ Kalp Atışı',
              heartBeats
                  .map((e) => (e['heartBeatRate'] ?? 0).toDouble())
                  .toList()
                  .cast<double>(),
              heartBeats
                  .map((e) => e['recordedAt'] ?? '')
                  .cast<String>()
                  .toList(),
              'BPM',
            ),
            sectionCard(
              '🌡️ Sıcaklık',
              temps
                  .map((e) => (e['temperature'] ?? 0).toDouble())
                  .toList()
                  .cast<double>(),
              temps.map((e) => e['recordedAt'] ?? '').cast<String>().toList(),
              '°C',
            ),
            sectionCard(
              '💧 Nem',
              temps
                  .map((e) => (e['humidity'] ?? 0).toDouble())
                  .toList()
                  .cast<double>(),
              temps.map((e) => e['recordedAt'] ?? '').cast<String>().toList(),
              '%',
            ),
            sectionCard(
              '🍽️ Çiğneme Aktivitesi',
              chews
                  .map((e) => (e['chewCount'] ?? 0).toDouble())
                  .toList()
                  .cast<double>(),
              chews.map((e) => e['recordedAt'] ?? '').cast<String>().toList(),
              'Geviş getirme süresi(dakika) ',
            ),
            const SizedBox(height: 30),
            Text(
              'Sayfa: ${(data!['currentPage'] ?? 0) + 1} / ${data!['totalPages'] ?? 1}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
