class Animal {
  final int id;
  final String tagId;
  final String? company;
  final String species;
  final DateTime birthDate;

  Animal({
    required this.id,
    required this.tagId,
    this.company,
    required this.species,
    required this.birthDate,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'] as int,
      tagId: json['tagId'] as String,
      company: json['company'] as String?,
      species: json['species'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tagId': tagId,
      'company': company,
      'species': species,
      'birthDate': birthDate.toIso8601String(),
    };
  }
}
