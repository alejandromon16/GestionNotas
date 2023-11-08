import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcode_verification/views/class_detail_view.dart';

class CreateSemestresView extends StatefulWidget {
  const CreateSemestresView({Key? key}) : super(key: key);

  @override
  State<CreateSemestresView> createState() => _CreateSemestresViewState();
}

class _CreateSemestresViewState extends State<CreateSemestresView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _semesterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Create Semestres View'),
        ElevatedButton(
          onPressed: () {
            _showSemesterInputDialog(context);
          },
          style: ElevatedButton.styleFrom(
            primary: const Color.fromARGB(255, 244, 54, 190), // Set the button color to red
          ),
          child: const Text('agregar materia'),
        ),
        _buildSemesterCards(),
      ],
    );
  }

  Future<void> _showSemesterInputDialog(BuildContext context) async {
    String semesterNumber = ''; 

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar materia'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  semesterNumber = value;
                },
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _saveSemester(semesterNumber);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _saveSemester(String semesterNumber) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;

      final semestersCollection = _firestore.collection('semesters');
      final querySnapshot = await semestersCollection
        .where('materia', isEqualTo: semesterNumber)
        .where('userId', isEqualTo: userId)
        .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('Semester number $semesterNumber already exists');
        return;
      }else{
        await semestersCollection.add({
          'userId': userId,
          'materia': semesterNumber,
        });
      }

      _semesterController.clear();
      setState(() {
      });
    }
  }

  Widget _buildSemesterCards() {
    return StreamBuilder(
      stream: _firestore.collection('semesters').where('userId', isEqualTo: _auth.currentUser?.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final data = snapshot.data as QuerySnapshot; 
        if (data.docs.isNotEmpty) {
          final semesterNumber = data.docs[0]['materia'];
          return Card(
            child: ListTile(
              title: Text('Materia: $semesterNumber'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ClassDetailScreen(materia: semesterNumber, materiaId:data.docs[0].id),
                  ),
                );
              },
            ),
          );
        } else {
          return const Text('No hay materias');
        }
      },
    );
  }

}
