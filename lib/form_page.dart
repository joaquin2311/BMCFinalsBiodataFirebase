import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController courseController =
      TextEditingController();

  final TextEditingController sectionController =
      TextEditingController();

  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  Future<void> saveData() async {
    final String name = nameController.text.trim();
    final String course = courseController.text.trim();
    final String section = sectionController.text.trim();

    // Check if fields are empty
    if (name.isEmpty || course.isEmpty || section.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields.'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      // Save data to Firestore
      await firestore.collection('students').add({
        'name': name,
        'course': course,
        'section': section,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student data saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the text fields
      nameController.clear();
      courseController.clear();
      sectionController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    sectionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Form'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Student Information',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Course
            TextField(
              controller: courseController,
              decoration: const InputDecoration(
                labelText: 'Course',
                hintText: 'Enter your course',
                prefixIcon: Icon(Icons.school),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Section
            TextField(
              controller: sectionController,
              decoration: const InputDecoration(
                labelText: 'Section',
                hintText: 'Enter your section',
                prefixIcon: Icon(Icons.class_),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            // Save button
            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: saveData,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Save Data',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
