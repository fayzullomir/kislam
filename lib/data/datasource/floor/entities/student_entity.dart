import 'package:floor/floor.dart';

@Entity(tableName: "student")
class StudentEntity {
  @PrimaryKey(autoGenerate: true)
  @ColumnInfo(name: "local_id")
  final int localId;

  @ColumnInfo(name: "id")
  final int id;

  @ColumnInfo(name: "first_name")
  final String firstName;

  @ColumnInfo(name: "last_name")
  final String lastName;

  @ColumnInfo(name: "patronymic_name")
  final String patronymicName;

  @ColumnInfo(name: "photo_path")
  final String photoPath;

  @ColumnInfo(name: "iin")
  final String iin;

  @ColumnInfo(name: "email")
  final String email;

  @ColumnInfo(name: "group_id")
  final int groupId;

  @ColumnInfo(name: "group_name")
  final String groupName;

  @ColumnInfo(name: "organization_id")
  final int organizationId;

  @ColumnInfo(name: "organization_name")
  final String organizationName;

  @ColumnInfo(name: "organization_description")
  final String organizationDescription;

  StudentEntity({
    this.localId = 0,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.patronymicName,
    required this.photoPath,
    required this.iin,
    required this.email,
    required this.groupId,
    required this.groupName,
    required this.organizationId,
    required this.organizationName,
    required this.organizationDescription,
  });

  String get fullName => "$lastName $firstName $patronymicName";
}
