import 'frooshyar_repository.dart';
import 'frooshyar_schema.dart';

/// Central database manager for FrooshYar.
///
/// Handles initialization and future migrations.
class FrooshyarDatabase {
  static final FrooshyarDatabase instance = FrooshyarDatabase._();

  FrooshyarDatabase._();

  late final FrooshyarRepository repository;

  Future<void> initialize() async {
    repository = FrooshyarRepository(
      databaseName: FrooshyarSchema.databaseName,
    );
    await repository.initialize();
  }

  Future<void> close() async {
    await repository.close();
  }
}
