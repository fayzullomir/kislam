import 'package:floor/floor.dart';

@Entity(tableName: 'attached_children')
class AttachedChildEntity {
  @primaryKey
  @ColumnInfo(name: 'child_id')
  final int id;

  @ColumnInfo(name: 'first_name')
  final String firstName;

  @ColumnInfo(name: 'last_name')
  final String lastName;

  @ColumnInfo(name: 'patronymic_name')
  final String patronymicName;

  @ColumnInfo(name: 'photo_path')
  final String photoPath;

  @ColumnInfo(name: 'iin')
  final String iin;

  @ColumnInfo(name: 'is_archived')
  final bool isArchived;

  AttachedChildEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.patronymicName,
    required this.photoPath,
    required this.iin,
    required this.isArchived,
  });

  String get fullName => "$lastName $firstName";
}
