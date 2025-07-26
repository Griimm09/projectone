import 'package:flutter/material.dart';
import 'package:projectone/views/home_screen.dart';
import '../controllers/test_controller.dart';
import '../widgets/question_widget.dart';

class TestView extends StatefulWidget {
  final String nama;
  final String ttl;
  final String umur;
  final String kelas;

  const TestView({
    super.key,
    required this.nama,
    required this.ttl,
    required this.umur,
    required this.kelas,
  });

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final controller = TestController();
  bool _isUploading = false;

  Future<void> uploadToFirestore(Map<String, double> hasil) async {
    setState(() => _isUploading = true);

    try {
      await controller.saveTestResults(
        name: widget.nama,
        birthPlaceDate: widget.ttl,
        age: widget.umur,
        studentClass: widget.kelas,
        results: hasil,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLB Surya Gemilang'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "SLB Bapak Musa",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                const Text(
                  "Personality Test",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(3, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Box ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                LinearProgressIndicator(
                  value: controller.getProgress(),
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.builder(
                    itemCount: controller.questions.length,
                    itemBuilder: (context, index) {
                      final question = controller.questions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: QuestionWidget(
                          question: question.text,
                          selected: question.answer,
                          onSelect: (value) {
                            setState(() {
                              controller.setAnswer(index, value);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () async {
                          if (controller.questions.any(
                            (q) => q.answer == null,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Harap isi semua pertanyaan terlebih dahulu.',
                                ),
                              ),
                            );
                          } else {
                            final hasil = controller.calculateResult();
                            await uploadToFirestore(hasil);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Selesai Test",
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
