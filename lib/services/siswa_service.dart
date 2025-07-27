import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSiswa({
    required String nama,
    required String tempat_lahir,
    required String tanggal_lahir,
    required String umur,
    required String kelas,
    required List<int> jawaban,
    required Map<String, double> hasil,
  }) async {
    try {
      await _firestore.collection('student').add({
        'nama': nama,
        'tempat_lahir' : tempat_lahir,
        'tanggal_lahir': tanggal_lahir,
        'umur': umur,
        'kelas': kelas,
        'jawaban': jawaban,
        'hasil': hasil,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Gagal menambahkan siswa: $e');
    }
  }
}
