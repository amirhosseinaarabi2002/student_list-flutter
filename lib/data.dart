import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createdAt;
  final String updatedAt;

  StudentData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });

  StudentData.fromJson(dynamic json)
    : id = json["id"],
      firstName = json["first_name"],
      lastName = json["last_name"],
      course = json["course"],
      score = json["score"],
      createdAt = json["created_at"],
      updatedAt = json["updated_at"];
}

class httpClient {
  static Dio dio = Dio(BaseOptions(baseUrl: "https://fapi.7learn.com/api/v1/"));
}

Future<List<StudentData>> getStudents() async {
  final response = await httpClient.dio.get("experts/student");
  print(response.data);
  final List<StudentData> students = [];
  if (response.data is List<dynamic>) {
    (response.data as List<dynamic>).forEach(
      (element) => students.add(StudentData.fromJson(element)),
    );
  }
  print(students.toString());
  return students;
}

Future<StudentData?>? saveStudent(
  String firstName,
  String lastName,
  String course,
  int score,
) async {
  final response = await httpClient.dio.post(
    "experts/student",
    data: {
      "first_name": firstName,
      "last_name": firstName,
      "course": firstName,
      "score": firstName,
    },
  );

  if (response.statusCode == 200) {
    return StudentData.fromJson(response.data);
  } else {
    throw Exception();
  }
}
