import 'package:floor/floor.dart';
import 'package:koreaislam/data/datasource/floor/entities/attached_child_entity.dart';

@dao
abstract class AttachedChildDao {
  @Query('SELECT * FROM attached_children ORDER BY last_name ASC')
  Future<List<AttachedChildEntity>> readAll();

  @Query('SELECT * FROM attached_children ORDER BY last_name ASC')
  Stream<List<AttachedChildEntity>> watchAll();

  @Query('SELECT COUNT(*) FROM attached_children')
  Future<int?> readCount();

  @Query('DELETE FROM attached_children')
  Future<void> clear();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(AttachedChildEntity child);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<AttachedChildEntity> children);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(AttachedChildEntity child);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateAll(List<AttachedChildEntity> children);
}
