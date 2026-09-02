/// Offline database schema definition for FrooshYar.
///
/// Tables are kept independent from UI so migrations can be added without
/// losing user data in future releases.
class FrooshyarSchema {
  static const databaseName = 'frooshyar.db';
  static const version = 2;

  static const customers = '''
  CREATE TABLE customers (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    phone TEXT,
    address TEXT,
    note TEXT,
    created_at INTEGER NOT NULL
  )
  ''';

  static const products = '''
  CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category_id INTEGER,
    price INTEGER NOT NULL DEFAULT 0,
    stock REAL NOT NULL DEFAULT 0,
    created_at INTEGER NOT NULL
  )
  ''';

  static const invoices = '''
  CREATE TABLE invoices (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_number TEXT NOT NULL,
    customer_id INTEGER,
    total_amount INTEGER NOT NULL DEFAULT 0,
    paid_amount INTEGER NOT NULL DEFAULT 0,
    created_at INTEGER NOT NULL
  )
  ''';

  static const invoiceItems = '''
  CREATE TABLE invoice_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity REAL NOT NULL,
    price INTEGER NOT NULL
  )
  ''';

  static const payments = '''
  CREATE TABLE payments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    invoice_id INTEGER NOT NULL,
    customer_id INTEGER,
    amount INTEGER NOT NULL DEFAULT 0,
    method TEXT NOT NULL,
    note TEXT,
    created_at INTEGER NOT NULL
  )
  ''';

  static const settings = '''
  CREATE TABLE settings (
    key TEXT PRIMARY KEY,
    value TEXT
  )
  ''';
}
