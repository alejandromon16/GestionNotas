// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ClassDetailScreen extends StatefulWidget {
  final String materia;
  final String materiaId;
  const ClassDetailScreen({super.key, required this.materia, required this.materiaId});

  @override
  _ClassDetailScreenState createState() => _ClassDetailScreenState();
}


class _ClassDetailScreenState extends State<ClassDetailScreen> {
  final TextEditingController _score1Controller = TextEditingController();
  final TextEditingController _score2Controller = TextEditingController();
  final TextEditingController _score3Controller = TextEditingController();
  double score1 = 0.0;
  double score2 = 0.0;
  double score3 = 0.0;
  double finalScore = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Nota (${widget.materia})'),
        backgroundColor: const Color.fromARGB(255, 255, 41, 155),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildScoreTextField(
              controller: _score1Controller,
              labelText: 'Enter Score 1 (35%)',
              onChanged: (value) {
                updateScore(value, (parsedScore) {
                  score1 = parsedScore;
                  calculateFinalScore();
                  updateRequiredScore();
                });
              },
            ),
            buildScoreTextField(
              controller: _score2Controller,
              labelText: 'Enter Score 2 (35%)',
              onChanged: (value) {
                updateScore(value, (parsedScore) {
                  score2 = parsedScore;
                  calculateFinalScore();
                  updateRequiredScore();
                });
              },
            ),
            buildScoreTextField(
              controller: _score3Controller,
              labelText: 'Enter Score 3 (30%)',
              onChanged: (value) {
                updateScore(value, (parsedScore) {
                  score3 = parsedScore;
                  calculateFinalScore();
                });
              },
            ),
            const SizedBox(height: 20),
            Text('Final Score: ${finalScore.toStringAsFixed(2)}'),
            Text('Required Score in Score 3: ${calculateRequiredScore().toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                saveScoresToFirestore();
              },
              child: const Text('Save Scores to Firestore'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScoreTextField({
    required TextEditingController controller,
    required String labelText,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
      onChanged: onChanged,
    );
  }

  void updateScore(String value, Function(double) updateFunction) {
    try {
      final parsedScore = double.parse(value);
      if (parsedScore >= 0 && parsedScore <= 100) {
        setState(() {
          updateFunction(parsedScore);
        });
      } else {
        _showError('Score should be between 0 and 100');
      }
    } on FormatException {
      _showError('Enter a valid number');
    }
  }

  void calculateFinalScore() {
    finalScore = (score1 * 0.35) + (score2 * 0.35) + (score3 * 0.30);
    setState(() {});
  }

  void updateRequiredScore() {
    final remainingScore = 51 - finalScore;
    final requiredScore = remainingScore / 0.3;
    _score3Controller.text = requiredScore.toStringAsFixed(2);
  }

  double calculateRequiredScore() {
    final remainingScore = 51 - finalScore;
    return remainingScore / 0.3;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void saveScoresToFirestore() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference semestersCollection = firestore.collection('semesters');

      final DocumentReference documentReference = semestersCollection.doc(widget.materiaId);
      final DocumentSnapshot existingData = await documentReference.get();

      if (existingData.exists) {
        final Map<String, dynamic> previousData = existingData.data() as Map<String, dynamic>;

        previousData['score1'] = score1;
        previousData['score2'] = score2;
        previousData['score3'] = score3;
        previousData['finalScore'] = finalScore;

        await documentReference.set(previousData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scores updated in Firestore'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document does not exist in Firestore'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      _showError('Failed to save scores: $error');
    }
  }

}

