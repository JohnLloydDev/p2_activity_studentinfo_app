import 'package:flutter/material.dart';
import 'package:flutter_application_p2activity/models/studentmodel.dart';
import 'package:flutter_application_p2activity/services/api_service.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  String _year = 'First Year';
  bool _enrolled = false;

  final StudentService _studentService = StudentService();

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final student = Student(
        firstname: _firstNameController.text,
        lastname: _lastNameController.text,
        course: _courseController.text,
        year: _year,
        enrolled: _enrolled,
      );

      try {
        await _studentService.createStudent(student);
        if(!mounted) return;
        Navigator.pop(context);
      } catch (e) {
        // Handle error
      
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter first name' : null,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter last name' : null,
              ),
              TextFormField(
                controller: _courseController,
                decoration: const InputDecoration(labelText: 'Course'),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter course' : null,
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
