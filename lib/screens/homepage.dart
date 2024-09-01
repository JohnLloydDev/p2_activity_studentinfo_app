import 'package:flutter/material.dart';
import 'package:flutter_application_p2activity/models/studentmodel.dart';
import 'package:flutter_application_p2activity/screens/student_detail_screen.dart';
import 'package:flutter_application_p2activity/screens/student_form_page.dart';
import 'package:flutter_application_p2activity/services/api_service.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = StudentService().fetchStudents();
  }

  Future<void> _refreshStudents() async {
    setState(() {
      _studentsFuture = StudentService().fetchStudents(); // Refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StudentFormScreen(),
                ),
              ).then((_) =>
                  _refreshStudents()); 
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Student>>(
        future: _studentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No students found'));
          } else {
            final students = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshStudents,
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    child: ListTile(
                      title: Text('${student.firstname} ${student.lastname}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StudentDetailScreen(student: student),
                          ),
                        ).then((_) =>
                            _refreshStudents());
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
