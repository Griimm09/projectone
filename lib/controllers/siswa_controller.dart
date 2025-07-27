// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:projectone/models/siswa_model.dart';

// class Question {
//   final String text;
//   int? answer; // Nilai jawaban, rentang -3 hingga 3

//   Question({required this.text, this.answer});
// }

// class TestController {
//   int currentIndex = 0;

//   final List<Question> _questions = [
//     Question(text: "Saya senang bekerja dalam tim."),
//     Question(text: "Saya mudah merasa cemas."),
//     Question(text: "Saya tertarik pada hal-hal baru."),
//     Question(text: "Saya cenderung menyelesaikan tugas tepat waktu."),
//   ];

//   List<Question> get questions => _questions;

//   void setAnswer(int index, int value) {
//     _questions[index].answer = value;
//   }

//   double getProgress() => (currentIndex + 1) / _questions.length;

//   bool get isLast => currentIndex == _questions.length - 1;

//   void next() {
//     if (currentIndex < _questions.length - 1) {
//       currentIndex++;
//     }
//   }

//   Map<String, double> calculateResult() {
//     int total = _questions.fold(0, (sum, q) => sum + (q.answer ?? 0));
//     return {
//       'extrovert': (total + 12) / 24 * 100,
//       'openness': (total + 8) / 16 * 100,
//       'anxiety': (total + 6) / 12 * 100,
//     };
//   }

//   Future<void> saveTestResults({
//     required String name,
//     required String birthPlace,
//     required String birthDate,
//     required String age,
//     required String studentClass,
//     required Map<String, double> results,
//   }) async {
//     final answers = _questions.map((q) => q.answer ?? 0).toList();

//     final docRef = FirebaseFirestore.instance.collection('student').doc();

//     final student = Student(
//       id: docRef.id,
//       name: name,
//       birthPlace: birthPlace,
//       birthDate: birthDate,
//       age: age,
//       studentClass: studentClass,
//       answers: answers,
//       results: results,
//       createdAt: DateTime.now(),
//     );

//     try {
//       await docRef.set(student.toMap());
//     } catch (e) {
//       throw Exception('Failed to save results: $e');
//     }
//   }
// }

// class StudentController {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String _collection = 'student';

//   /// Tambah data siswa baru
//   Future<void> addStudent(Student student) async {
//     try {
//       final docRef = _firestore.collection(_collection).doc();
//       final studentWithId = Student(
//         id: docRef.id,
//         name: student.name,
//         birthPlace: student.birthPlace,
//         birthDate: student.birthDate,
//         age: student.age,
//         studentClass: student.studentClass,
//         answers: student.answers,
//         results: student.results,
//         createdAt: student.createdAt,
//       );

//       await docRef.set(studentWithId.toMap());
//     } catch (e) {
//       throw Exception('Gagal menyimpan data: $e');
//     }
//   }

//   /// Ambil semua data siswa
//   Future<List<Student>> getAllStudents() async {
//     try {
//       final snapshot = await _firestore.collection(_collection).get();
//       return snapshot.docs.map((doc) {
//         return Student.fromMap(doc.data(), doc.id);
//       }).toList();
//     } catch (e) {
//       throw Exception('Gagal mengambil data siswa: $e');
//     }
//   }

//   /// Update data siswa
//   Future<void> updateStudent(String id, Student updatedStudent) async {
//     try {
//       await _firestore
//           .collection(_collection)
//           .doc(id)
//           .update(updatedStudent.toMap());
//     } catch (e) {
//       throw Exception('Gagal memperbarui data siswa: $e');
//     }
//   }

//   /// Hapus data siswa
//   Future<void> deleteStudent(String id) async {
//     try {
//       await _firestore.collection(_collection).doc(id).delete();
//     } catch (e) {
//       throw Exception('Gagal menghapus data siswa: $e');
//     }
//   }
// }
