import 'package:flutter/material.dart';
import '../controllers/test_controller.dart';
import 'result_view.dart';
import 'form_view.dart';
import '../widgets/question_widget.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final controller = TestController();

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
                  value: controller.questions
                          .where((q) => q.answer != null)
                          .length /
                      controller.questions.length,
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

                // Tombol lihat hasil
                ElevatedButton(
                  onPressed: () {
                    if (controller.questions.any((q) => q.answer == null)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Harap isi semua pertanyaan terlebih dahulu.'),
                        ),
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ResultView(results: controller.calculateResult()),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child:
                      const Text("Lihat Hasil", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 70), // beri jarak agar tombol di bawah tidak ketumpuk
              ],
            ),
          ),

          // Tombol kembali pojok kanan bawah
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const FormView()),
                );
              },
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.arrow_back),
              label: const Text("Kembali ke Form"),
            ),
          )
        ],
      ),
    );
  }
}
