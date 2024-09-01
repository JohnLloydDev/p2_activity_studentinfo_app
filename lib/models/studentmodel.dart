class Student {
  final String id;
  final String firstname;
  final String lastname;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    this.id = '',
    required this.firstname,
    required this.lastname,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      course: json['course'] ?? '',
      year: json['year'] ?? '',
      enrolled: json['enrolled'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'course': course,
      'year': year,
      'enrolled': enrolled,
    };
  }
}
