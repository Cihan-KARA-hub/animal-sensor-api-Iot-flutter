class AnimalHealthModel {
  String _treatment;
  String _veterinarian;
  int _animalId;
  String _diseaseName;
  DateTime _diagnosisDate;
  DateTime _recoveryDate;

  AnimalHealthModel({
    required String treatment,
    required String veterinarian,
    required int animalId,
    required String diseaseName,
    required DateTime diagnosisDate,
    required DateTime recoveryDate,
  })  : _treatment = treatment,
        _veterinarian = veterinarian,
        _animalId = animalId,
        _diseaseName = diseaseName,
        _diagnosisDate = diagnosisDate,
        _recoveryDate = recoveryDate;

  String get treatment => _treatment;
  set treatment(String value) => _treatment = value;

  String get veterinarian => _veterinarian;
  set veterinarian(String value) => _veterinarian = value;

  int get animalId => _animalId;
  set animalId(int value) => _animalId = value;

  String get diseaseName => _diseaseName;
  set diseaseName(String value) => _diseaseName = value;

  DateTime get diagnosisDate => _diagnosisDate;
  set diagnosisDate(DateTime value) => _diagnosisDate = value;

  DateTime get recoveryDate => _recoveryDate;
  set recoveryDate(DateTime value) => _recoveryDate = value;

  Map<String, dynamic> toJson() {
    return {
      'treatment': _treatment,
      'veterinarian': _veterinarian,
      'animalId': _animalId,
      'diseaseName': _diseaseName,
      'diagnosisDate': _diagnosisDate.toIso8601String(),
      'recoveryDate': _recoveryDate.toIso8601String(),
    };
  }

  factory AnimalHealthModel.fromJson(Map<String, dynamic> json) {
    return AnimalHealthModel(
      treatment: json['treatment'],
      veterinarian: json['veterinarian'],
      animalId: json['animalId'],
      diseaseName: json['diseaseName'],
      diagnosisDate: DateTime.parse(json['diagnosisDate']),
      recoveryDate: DateTime.parse(json['recoveryDate']),
    );
  }
}
