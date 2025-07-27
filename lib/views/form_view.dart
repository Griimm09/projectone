import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'test_view.dart';

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();
  final _umurController = TextEditingController();
  final _kelasController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    _namaController.dispose();
    _tempatLahirController.dispose();
    _tanggalLahirController.dispose();
    _umurController.dispose();
    _kelasController.dispose();
    super.dispose();
  }

  Future<void> _selectTanggalLahir(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Pilih Tanggal Lahir',
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _tanggalLahirController.text =
            DateFormat('dd-MM-yyyy').format(pickedDate);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Gabungkan Tempat & Tanggal Lahir
      final tempatTanggalLahir =
          '${_tempatLahirController.text.trim()}, ${_tanggalLahirController.text.trim()}';

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TestView(
            nama: _namaController.text,
            tempat_lahir: tempatTanggalLahir, // kirim gabungan
            tanggal_lahir: '', // optional: kosongkan kalau tidak diperlukan
            umur: _umurController.text,
            kelas: _kelasController.text,
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      filled: true,
      fillColor: Colors.blue.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Formulir Siswa"),
        backgroundColor: const Color(0xFF3674B5),
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Sebelum memulai tes,\nsilakan lengkapi data berikut:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 28),

              // Nama
              TextFormField(
                controller: _namaController,
                decoration: _inputDecoration("Nama Lengkap"),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // Tempat Lahir
              TextFormField(
                controller: _tempatLahirController,
                decoration: _inputDecoration("Tempat Lahir"),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Tempat lahir wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Tanggal Lahir (pakai DatePicker)
              TextFormField(
                controller: _tanggalLahirController,
                readOnly: true,
                decoration: _inputDecoration("Tanggal Lahir"),
                onTap: () => _selectTanggalLahir(context),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Tanggal lahir wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Umur
              TextFormField(
                controller: _umurController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Umur"),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Umur wajib diisi'
                    : null,
              ),
              const SizedBox(height: 20),

              // Kelas
              TextFormField(
                controller: _kelasController,
                decoration: _inputDecoration("Kelas"),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Kelas wajib diisi'
                    : null,
              ),
              const SizedBox(height: 36),

              // Tombol Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    "Lanjut ke Tes",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
