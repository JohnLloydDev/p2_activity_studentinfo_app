import 'package:flutter/material.dart';
import 'package:flutter_application_p2activity/models/studentmodel.dart';
import '../services/api_service.dart';
import 'student_update_page.dart'; // Import the update screen

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  const StudentDetailScreen({super.key, required this.student});

@override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Student student;

  @override
  void initState() {
    super.initState();
    student = widget.student;
  }

  Future<void> _deleteStudent() async {
      await StudentService().deleteStudent(student.id);
      if(!mounted) return;

      Navigator.pop(context);
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Confirm the delete operation
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Student'),
                    content: Text('Are you sure you want to delete ${student.firstname} ${student.lastname}?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); 
                          _deleteStudent(); 
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${student.firstname}', style: const TextStyle(fontSize: 18)),
            Text('Last Name: ${student.lastname}', style: const TextStyle(fontSize: 18)),
            Text('Course: ${student.course}', style: const TextStyle(fontSize: 18)),
            Text('Year: ${student.year}', style: const TextStyle(fontSize: 18)),
            Text('Enrolled: ${student.enrolled ? "Yes" : "No"}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedStudent = await Navigator.push<Student>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentUpdateScreen(student: student),
                  ),
                );
                if (updatedStudent != null) {
                  setState(() {
                    student = updatedStudent;
                  });
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
