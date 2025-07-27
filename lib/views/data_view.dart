import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'student';

  // Untuk melacak item yang sedang diperluas
  final Set<String> expandedItems = {};

  Future<void> _deleteStudent(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil dihapus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  String formatResult(Map<String, dynamic> results) {
    return results.entries
        .map((e) => '${e.key}: ${e.value.toStringAsFixed(1)}%')
        .join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Siswa'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection(_collection)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Terjadi kesalahan.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('Tidak ada data siswa.'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final id = docs[index].id;

              final name = data['name'] ?? '-';
              final age = data['age'] ?? '-';
              final birthDate = data['birthDate'] ?? '-';
              final studentClass = data['studentClass'] ?? '-';
              final results = data['results'] as Map<String, dynamic>? ?? {};

              final isExpanded = expandedItems.contains(id);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              expandedItems.remove(id);
                            } else {
                              expandedItems.add(id);
                            }
                          });
                        },
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _showEditPopup(context, id, data),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteDialog(context, id, name),
                          ),
                        ],
                      ),
                    ),
                    if (isExpanded)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '''
Umur: $age tahun
TTL: $birthDate
Kelas: $studentClass
Hasil Tes:
${formatResult(results)}
''',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id, String name) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text('Yakin ingin menghapus data $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteStudent(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showEditPopup(BuildContext context, String id, Map<String, dynamic> data) {
    final _nameController = TextEditingController(text: data['name']);
    final _ageController = TextEditingController(text: data['age']?.toString());
    final _birthPlaceController = TextEditingController(text: data['birthPlace']);
    final _birthDateController = TextEditingController(text: data['birthDate']);
    final _classController = TextEditingController(text: data['studentClass']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Data Siswa'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Umur'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _birthPlaceController,
                decoration: const InputDecoration(labelText: 'Tempat Lahir'),
              ),
              TextField(
                controller: _birthDateController,
                decoration: const InputDecoration(labelText: 'Tanggal Lahir'),
              ),
              TextField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Kelas'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _firestore.collection(_collection).doc(id).update({
                  'name': _nameController.text.trim(),
                  'age': int.tryParse(_ageController.text.trim()) ?? 0,
                  'birthPlace': _birthPlaceController.text.trim(),
                  'birthDate': _birthDateController.text.trim(),
                  'studentClass': _classController.text.trim(),
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Data berhasil diperbarui')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal update data: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
