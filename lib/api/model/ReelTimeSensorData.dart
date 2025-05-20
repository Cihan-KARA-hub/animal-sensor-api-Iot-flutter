class ReelTimeSensorModel {
  List<HeartBeats>? heartBeats;
  List<TemperatureHumidities>? temperatureHumidities;
  List<ChewingActivities>? chewingActivities;
  int? currentPage;
  int? totalPages;
  int? totalElements;

  ReelTimeSensorModel(
      {this.heartBeats,
      this.temperatureHumidities,
      this.chewingActivities,
      this.currentPage,
      this.totalPages,
      this.totalElements});

  ReelTimeSensorModel.fromJson(Map<String, dynamic> json) {
    if (json['heartBeats'] != null) {
      heartBeats = <HeartBeats>[];
      json['heartBeats'].forEach((v) {
        heartBeats!.add(new HeartBeats.fromJson(v));
      });
    }
    if (json['temperatureHumidities'] != null) {
      temperatureHumidities = <TemperatureHumidities>[];
      json['temperatureHumidities'].forEach((v) {
        temperatureHumidities!.add(new TemperatureHumidities.fromJson(v));
      });
    }
    if (json['chewingActivities'] != null) {
      chewingActivities = <ChewingActivities>[];
      json['chewingActivities'].forEach((v) {
        chewingActivities!.add(new ChewingActivities.fromJson(v));
      });
    }
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalElements = json['totalElements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.heartBeats != null) {
      data['heartBeats'] = this.heartBeats!.map((v) => v.toJson()).toList();
    }
    if (this.temperatureHumidities != null) {
      data['temperatureHumidities'] =
          this.temperatureHumidities!.map((v) => v.toJson()).toList();
    }
    if (this.chewingActivities != null) {
      data['chewingActivities'] =
          this.chewingActivities!.map((v) => v.toJson()).toList();
    }
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    return data;
  }
}

class HeartBeats {
  int? id;
  int? heartBeatRate;
  String? recordedAt;

  HeartBeats({this.id, this.heartBeatRate, this.recordedAt});

  HeartBeats.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    heartBeatRate = json['heartBeatRate'];
    recordedAt = json['recordedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['heartBeatRate'] = this.heartBeatRate;
    data['recordedAt'] = this.recordedAt;
    return data;
  }
}

class TemperatureHumidities {
  int? id;
  double? temperature;
  int? humidity;
  String? recordedAt;

  TemperatureHumidities(
      {this.id, this.temperature, this.humidity, this.recordedAt});

  TemperatureHumidities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    temperature = json['temperature'];
    humidity = json['humidity'];
    recordedAt = json['recordedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['temperature'] = this.temperature;
    data['humidity'] = this.humidity;
    data['recordedAt'] = this.recordedAt;
    return data;
  }
}

class ChewingActivities {
  int? id;
  int? chewCount;
  String? recordedAt;

  ChewingActivities({this.id, this.chewCount, this.recordedAt});

  ChewingActivities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chewCount = json['chewCount'];
    recordedAt = json['recordedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chewCount'] = this.chewCount;
    data['recordedAt'] = this.recordedAt;
    return data;
  }
}
