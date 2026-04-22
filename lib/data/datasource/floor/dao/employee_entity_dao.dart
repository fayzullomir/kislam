import 'package:koreaislam/data/datasource/floor/entities/employee_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class EmployeeEntityDao {
  @Query('SELECT * FROM employees LIMIT 1')
  Future<EmployeeEntity?> readEmployee();

  @Query('SELECT * FROM employees LIMIT 1')
  Stream<EmployeeEntity?> watchEmployee();

  @Query('DELETE FROM employees')
  Future<void> clear();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(EmployeeEntity employee);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(EmployeeEntity employee);
}
