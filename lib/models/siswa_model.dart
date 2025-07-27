import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String birthPlace;
  final String birthDate;
  final String age;
  final String studentClass;
  final List<int> answers;
  final Map<String, double> results;
  final DateTime createdAt;

  Student({
    this.id = '',
    required this.name,
    required this.birthPlace,
    required this.birthDate,
    required this.age,
    required this.studentClass,
    required this.answers,
    required this.results,
    required this.createdAt,
  });

  /// Konversi data ke Map agar bisa dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthPlace': birthPlace,
      'birthDate': birthDate,
      'age': age,
      'class': studentClass,
      'answers': answers,
      'results': results,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Membuat objek Student dari Map (data Firestore)
  factory Student.fromMap(Map<String, dynamic> map, String docId) {
    // Ambil dan validasi jawaban
    final List<dynamic> rawAnswers = map['answers'] ?? [];
    final List<int> answers = rawAnswers.cast<int>();
    if (answers.any((a) => a < -3 || a > 3)) {
      throw Exception('Invalid answer value');
    }

    // Ambil dan validasi hasil
    final Map<String, dynamic> rawResults = map['results'] ?? {};
    final Map<String, double> results = rawResults.map((key, value) {
      final v = (value is int) ? value.toDouble() : value;
      if (v < 0 || v > 100) {
        throw Exception('Invalid result value for $key');
      }
      return MapEntry(key, v);
    });

    // Ambil waktu pembuatan
    final Timestamp createdTimestamp = map['createdAt'] as Timestamp;

    return Student(
      id: map['id'] ?? docId,
      name: map['name'] ?? '',
      birthPlace: map['birthPlace'] ?? '',
      birthDate: map['birthDate'] ?? '',
      age: map['age'] ?? '',
      studentClass: map['class'] ?? '',
      answers: answers,
      results: results,
      createdAt: createdTimestamp.toDate(),
    );
  }
}
