import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/studentmodel.dart';

class StudentService {
  static const String apiUrl = 'https://p2-activity-studentinfo-api.vercel.app/students/';

  Future<List<Student>> fetchStudents() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Student.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<Student> createStudent(Student student) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode == 201) {
      return Student.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create student');
    }
  }

  Future<void> updateStudent(String id, Student student) async {
    final response = await http.put(
      Uri.parse('$apiUrl$id'), // Adjusted URL formatting
      headers: {'Content-Type': 'application/json'},
      body: json.encode(student.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    }
  }

  Future<void> deleteStudent(String id) async {
    final response =
        await http.delete(Uri.parse('$apiUrl$id')); // Adjusted URL formatting

    if (response.statusCode != 200) {
      throw Exception('Failed to delete student');
    }
  }
}
