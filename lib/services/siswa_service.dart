import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSiswa({
    required String nama,
    required String ttl,
    required String umur,
    required String kelas,
    required List<int> jawaban,
    required Map<String, double> hasil,
  }) async {
    try {
      await _firestore.collection('siswa').add({
        'nama': nama,
        'ttl': ttl,
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
