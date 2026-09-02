import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../database/frooshyar_schema.dart';
import '../database/sqlite/frooshyar_sqlite_helper.dart';

/// Creates and restores offline SQLite backups for FrooshYar.
///
/// Backups are copied to the app documents directory and can later be shared
/// or moved by the UI layer. Restore validates that the source file exists and
/// is a readable SQLite database before replacing the active database.
class FrooshyarBackupService {
  FrooshyarBackupService({FrooshyarSqliteHelper? helper})
      : helper = helper ?? FrooshyarSqliteHelper.instance;

  final FrooshyarSqliteHelper helper;

  Future<String> exportBackup() async {
    final db = await helper.database;
    final sourcePath = db.path;
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('FrooshYar database file was not found.');
    }

    // Flush pending SQLite work before copying the database file.
    await db.rawQuery('PRAGMA wal_checkpoint(FULL)');

    final documents = await getApplicationDocumentsDirectory();
    final backupDirectory = Directory('${documents.path}/frooshyar_backups');
    if (!await backupDirectory.exists()) {
      await backupDirectory.create(recursive: true);
    }

    final now = DateTime.now().toUtc();
    final stamp = [
      now.year.toString().padLeft(4, '0'),
      now.month.toString().padLeft(2, '0'),
      now.day.toString().padLeft(2, '0'),
      now.hour.toString().padLeft(2, '0'),
      now.minute.toString().padLeft(2, '0'),
      now.second.toString().padLeft(2, '0'),
    ].join();

    final destination = File('${backupDirectory.path}/frooshyar_$stamp.db');
    await source.copy(destination.path);
    return destination.path;
  }

  Future<bool> restoreBackup(String path) async {
    final backup = File(path);
    if (!await backup.exists() || await backup.length() == 0) {
      return false;
    }

    Database? validationDb;
    try {
      validationDb = await openDatabase(path, readOnly: true, singleInstance: false);
      final validation = await validationDb.rawQuery('PRAGMA integrity_check');
      final isValid = validation.isNotEmpty &&
          validation.first.values.isNotEmpty &&
          validation.first.values.first.toString().toLowerCase() == 'ok';
      if (!isValid) return false;
    } catch (_) {
      return false;
    } finally {
      await validationDb?.close();
    }

    final databasePath =
        '${await getDatabasesPath()}/${FrooshyarSchema.databaseName}';
    final target = File(databasePath);
    final safetyCopy = File('$databasePath.before_restore');

    await helper.close();

    try {
      if (await target.exists()) {
        await target.copy(safetyCopy.path);
      }
      await backup.copy(target.path);

      // Opening through the helper applies any required schema migrations.
      await helper.database;

      if (await safetyCopy.exists()) {
        await safetyCopy.delete();
      }
      return true;
    } catch (_) {
      await helper.close();
      if (await safetyCopy.exists()) {
        await safetyCopy.copy(target.path);
        await safetyCopy.delete();
      }
      await helper.database;
      return false;
    }
  }
}
