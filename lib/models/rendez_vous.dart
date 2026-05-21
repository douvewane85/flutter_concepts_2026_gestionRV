class RendezVous {
  final String id;
  final String title;
  final DateTime date;
  final String? description;

  RendezVous({
    String? id,
    required this.title,
    required this.date,
    this.description,
  }) : id = id ?? '${DateTime.now().microsecondsSinceEpoch}_${title.hashCode}';

  // Copy helper
  RendezVous copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? description,
  }) {
    return RendezVous(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  // Convert to Map for JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  // Create from Map
  factory RendezVous.fromMap(Map<String, dynamic> map) {
    return RendezVous(
      id: map['id'] as String?,
      title: map['title'] as String,
      date: DateTime.parse(map['date'] as String),
      description: map['description'] as String?,
    );
  }
}