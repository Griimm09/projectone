import '../models/question_model.dart';

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

  double getProgress() => currentIndex / _questions.length;

  bool get isLast => currentIndex == _questions.length - 1;

  void next() {
    if (currentIndex < _questions.length - 1) currentIndex++;
  }

  Map<String, double> calculateResult() {
    // Dummy calculation, ganti sesuai logika kepribadian
    int total = _questions.fold(0, (sum, q) => sum + (q.answer ?? 0));
    return {
      'Ekstrovert': (total + 12) / 24 * 100,
      'Terbuka': (total + 8) / 16 * 100,
      'Cemas': (total + 6) / 12 * 100,
    };
  }
}
