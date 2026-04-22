import 'package:koreaislam/data/datasource/floor/entities/student_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class StudentEntityDao {
  @Query('SELECT * FROM student LIMIT 1 ')
  Future<StudentEntity?> readUser();

  @Query('SELECT * FROM student LIMIT 1 ')
  Stream<StudentEntity?> watchUser();

  @Query('DELETE FROM student ')
  Future<void> clear();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(StudentEntity user);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(StudentEntity user);
}
