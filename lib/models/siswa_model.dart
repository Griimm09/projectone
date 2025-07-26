import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String name;
  final String birthPlaceDate;
  final String age;
  final String studentClass;
  final List<int> answers;
  final Map<String, double> results;
  final DateTime createdAt;

  Student({
    this.id = '',
    required this.name,
    required this.birthPlaceDate,
    required this.age,
    required this.studentClass,
    required this.answers,
    required this.results,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthPlaceDate': birthPlaceDate,
      'age': age,
      'class': studentClass,
      'answers': answers,
      'results': results,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Student.fromMap(Map<String, dynamic> map, String id) {
    // Validate answers are in range -3 to 3
    final answers = List<int>.from(map['answers'] ?? []);
    if (answers.any((a) => a < -3 || a > 3)) {
      throw Exception('Invalid answer value');
    }

    // Validate results percentages are between 0-100
    final results = Map<String, double>.from(map['results'] ?? {});
    if (results.values.any((v) => v < 0 || v > 100)) {
      throw Exception('Invalid result value');
    }

    return Student(
      id: id,
      name: map['name'] ?? '',
      birthPlaceDate: map['birthPlaceDate'] ?? '',
      age: map['age'] ?? '',
      studentClass: map['class'] ?? '',
      answers: answers,
      results: results,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
