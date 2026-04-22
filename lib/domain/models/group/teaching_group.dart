import 'group.dart';

class TeachingGroup {
  final Group group;
  final List<Student> students;

  TeachingGroup({required this.group, required this.students});
}


class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String patronymicName;
  final String photoPath;
  final String iin;
  final bool isArchived;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.patronymicName,
    required this.photoPath,
    required this.iin,
    required this.isArchived,
  });
}
