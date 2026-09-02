import 'frooshyar_schema.dart';

/// Repository abstraction for offline FrooshYar data.
///
/// Database drivers can be changed later without changing UI code.
class FrooshyarRepository {
  final String databaseName;

  FrooshyarRepository({this.databaseName = FrooshyarSchema.databaseName});

  Future<void> initialize() async {
    // SQLite initialization will be connected here.
    // Migration handling keeps previous user data safe.
  }

  Future<void> close() async {
    // Close database connection.
  }
}
