import 'package:floor/floor.dart';
import 'package:koreaislam/data/datasource/floor/entities/parent_entity.dart';

@dao
abstract class ParentEntityDao {
  @Query('SELECT * FROM parents LIMIT 1')
  Future<ParentEntity?> readParent();

  @Query('SELECT * FROM parents LIMIT 1')
  Stream<ParentEntity?> watchParent();

  @Query('DELETE FROM parents')
  Future<void> clear();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insert(ParentEntity parent);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(ParentEntity parent);
}
