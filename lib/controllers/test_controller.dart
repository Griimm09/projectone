import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectone/models/siswa_model.dart';

class TestController {
  int currentIndex = 0;

  final List<Question> _questions = [
    Question(text: "Saya senang bekerja dalam tim."),
    Question(text: "Saya mudah merasa cemas."),
    Question(text: "Saya tertarik pada hal-hal baru."),
    Question(text: "Saya cenderung menyelesaikan tugas tepat waktu."),
  ];

  List<Question> get questions => _questions;

  void setAnswer(int index, int value) {
    _questions[index].answer = value;
  }

  double getProgress() => (currentIndex + 1) / _questions.length;

  bool get isLast => currentIndex == _questions.length - 1;

  void next() {
    if (currentIndex < _questions.length - 1) {
      currentIndex++;
    }
  }

  Map<String, double> calculateResult() {
    int total = _questions.fold(0, (sum, q) => sum + (q.answer ?? 0));
    return {
      'extrovert': (total + 12) / 24 * 100,
      'openness': (total + 8) / 16 * 100,
      'anxiety': (total + 6) / 12 * 100,
    };
  }

  Future<void> saveTestResults({
    required String name,
    required String birthPlace,
    required String birthDate,
    required String age,
    required String studentClass,
    required Map<String, double> results,
  }) async {
    final answers = _questions.map((q) => q.answer ?? 0).toList();

    // Buat reference dokumen dengan ID otomatis
    final docRef = FirebaseFirestore.instance.collection('student').doc();

    final student = Student(
      id: docRef.id,
      name: name,
      birthPlace: birthPlace,
      birthDate: birthDate,
      age: age,
      studentClass: studentClass,
      answers: answers,
      results: results,
      createdAt: DateTime.now(),
    );

    try {
      // Gunakan .set agar ID bisa disimpan ke dalam dokumen
      await docRef.set(student.toMap());
    } catch (e) {
      throw Exception('Failed to save results: $e');
    }
  }
}

class Question {
  final String text;
  int? answer; // Nilai jawaban, rentang -3 hingga 3

  Question({required this.text, this.answer});
}
