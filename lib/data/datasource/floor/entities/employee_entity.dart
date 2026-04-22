import 'package:floor/floor.dart';

@Entity(tableName: 'employees')
class EmployeeEntity {
  @primaryKey
  final int id;

  final String firstName;
  final String lastName;
  final String iin;
  final int role;
  final int position;
  final String email;
  final String photoPath;

  final int organizationId;
  final String organizationName;
  final String organizationDescription;

  EmployeeEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.iin,
    required this.role,
    required this.position,
    required this.email,
    required this.photoPath,
    required this.organizationId,
    required this.organizationName,
    required this.organizationDescription,
  });
}
