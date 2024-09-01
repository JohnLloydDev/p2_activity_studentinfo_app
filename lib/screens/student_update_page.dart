import 'package:flutter/material.dart';
import 'package:flutter_application_p2activity/models/studentmodel.dart';
import 'package:flutter_application_p2activity/services/api_service.dart';

class StudentUpdateScreen extends StatefulWidget {
  final Student student;

  const StudentUpdateScreen({super.key, required this.student});

  @override
  State<StudentUpdateScreen> createState() => _StudentUpdateScreenState();
}

class _StudentUpdateScreenState extends State<StudentUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _courseController;
  late String _year;
  late bool _enrolled;

  final StudentService _studentService = StudentService();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student.firstname);
    _lastNameController = TextEditingController(text: widget.student.lastname);
    _courseController = TextEditingController(text: widget.student.course);
    _year = widget.student.year;
    _enrolled = widget.student.enrolled;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedStudent = Student(
        id: widget.student.id,
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        course: _courseController.text,
        year: _year,
        enrolled: _enrolled,
      );

      try {
        await _studentService.updateStudent(updatedStudent.id, updatedStudent);
        if (mounted) {
          Navigator.pop(context, updatedStudent);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update student: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter last name' : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter course' : null,
              ),
              DropdownButtonFormField<String>(
                value: _year,
                items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _year = value ?? 'First Year';
                  });
                },
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              SwitchListTile(
                title: const Text('Enrolled'),
                value: _enrolled,
                onChanged: (value) {
                  setState(() {
                    _enrolled = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
