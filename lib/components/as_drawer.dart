import 'package:flutter/material.dart';

/// Shared drawer shell for FrooshYar.
///
/// The component is intentionally separated from page routing so future AS
/// Team applications can reuse the same navigation style.
class AsDrawer extends StatelessWidget {
  final String username;
  final VoidCallback? onProfileTap;
  final ValueChanged<String>? onItemSelected;

  const AsDrawer({
    super.key,
    this.username = 'کاربر فروشیار',
    this.onProfileTap,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      ('خانه', Icons.home_outlined),
      ('ثبت فروش', Icons.point_of_sale_outlined),
      ('فاکتورها', Icons.receipt_long_outlined),
      ('مشتریان', Icons.people_outline),
      ('کالاها', Icons.inventory_2_outlined),
      ('انبار', Icons.warehouse_outlined),
      ('صندوق', Icons.account_balance_wallet_outlined),
      ('گزارش مالی', Icons.analytics_outlined),
      ('پشتیبان‌گیری', Icons.backup_outlined),
      ('تنظیمات', Icons.settings_outlined),
      ('درباره نرم‌افزار', Icons.info_outline),
      ('تماس با ما', Icons.contact_support_outlined),
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              InkWell(
                onTap: onProfileTap,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 38,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              for (final item in items)
                ListTile(
                  leading: Icon(item.$2),
                  title: Text(item.$1),
                  onTap: () => onItemSelected?.call(item.$1),
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('خروج'),
                onTap: () => onItemSelected?.call('خروج'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
