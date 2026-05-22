class RendezVous {
  final int? id;
  final String title;
  final DateTime date;
  final String? description;

  RendezVous({
    this.id,
    required this.title,
    required this.date,
    this.description,
  });

  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      id: json['id'] as int?,
      title: json['title'] as String,
      date: DateTime.parse(json['dateRv'] as String),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'dateRv': date.toIso8601String(),
      'description': description,
    };
  }
}