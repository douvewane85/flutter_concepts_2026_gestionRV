class RendezVous {
  final String title;
  final DateTime date;
  final String? description;

  RendezVous({
    required this.title,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory RendezVous.fromJson(Map<String, dynamic> json) {
    return RendezVous(
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String?,
    );
  }
}