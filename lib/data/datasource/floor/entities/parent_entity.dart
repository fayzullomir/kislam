import 'package:floor/floor.dart';

@Entity(tableName: 'parents')
class ParentEntity {
  @primaryKey
  final int id;

  final String firstName;
  final String lastName;
  final String iin;
  final String email;
  final String phoneNumber;
  final int parentType;
  final String photoPath;

  ParentEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.iin,
    required this.email,
    required this.phoneNumber,
    required this.parentType,
    required this.photoPath,
  });
}
