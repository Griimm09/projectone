import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projectone/models/siswa_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveStudent(Student student) async {
    await _firestore.collection('student').add(student.toMap());
  }

  Future<List<Student>> getStudent() async {
    final querySnapshot = await _firestore
        .collection('student')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs.map((doc) {
      return Student.fromMap(doc.data(), doc.id);
    }).toList();
  }

  Stream<List<Student>> streamStudent() {
    return _firestore
        .collection('student')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Student.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }
}
