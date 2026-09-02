import 'package:sqflite/sqflite.dart';
import '../frooshyar_schema.dart';

/// SQLite helper for FrooshYar offline storage.
class FrooshyarSqliteHelper {
  static final FrooshyarSqliteHelper instance = FrooshyarSqliteHelper._();

  FrooshyarSqliteHelper._();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _init();
    return _database!;
  }

  Future<Database> _init() async {
    final path = '${await getDatabasesPath()}/${FrooshyarSchema.databaseName}';

    return openDatabase(
      path,
      version: FrooshyarSchema.version,
      onCreate: (db, version) async {
        await db.execute(FrooshyarSchema.customers);
        await db.execute(FrooshyarSchema.products);
        await db.execute(FrooshyarSchema.invoices);
        await db.execute(FrooshyarSchema.invoiceItems);
        await db.execute(FrooshyarSchema.settings);
      },
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
