import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSiswa({
    required String name,
    required String birthPlace,
    required String birthDate,
    required String age,
    required String studentClass,
    required List<int> answers,
    required Map<String, double> results,
  }) async {
    try {
      await _firestore.collection('student').add({
        'name': name,
        'birth_place': birthPlace,
        'birth_date': birthDate,
        'age': age,
        'student_class': studentClass,
        'answers': answers,
        'results': results,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal menambahkan siswa: $e');
    }
  }
}
