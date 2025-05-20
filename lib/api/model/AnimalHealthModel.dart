class AnimalHealthModel {
  int? id;
  String? treatment;
  String? veterinarian;
  int? animalId;
  String? diseaseName;
  String? diagnosisDate;
  String? recoveryDate;

  AnimalHealthModel(
      {this.treatment,
      this.id,
      this.veterinarian,
      this.animalId,
      this.diseaseName,
      this.diagnosisDate,
      this.recoveryDate});

  AnimalHealthModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treatment = json['treatment'];
    veterinarian = json['veterinarian'];
    animalId = json['animalId'];
    diseaseName = json['diseaseName'];
    diagnosisDate = json['diagnosisDate'];
    recoveryDate = json['recoveryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['treatment'] = this.treatment;
    data['veterinarian'] = this.veterinarian;
    data['animalId'] = this.animalId;
    data['diseaseName'] = diseaseName;
    data['diagnosisDate'] = this.diagnosisDate;
    data['recoveryDate'] = this.recoveryDate;
    return data;
  }
}
