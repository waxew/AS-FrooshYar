import 'package:flutter/material.dart';

/// Mobile navigation structure for FrooshYar.
class FrooshyarNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onChanged;

  const FrooshyarNavigation({
    super.key,
    this.currentIndex = 0,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onChanged,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'خانه',
          ),
          NavigationDestination(
            icon: Icon(Icons.point_of_sale_outlined),
            label: 'فروش',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'کالاها',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            label: 'مشتریان',
          ),
        ],
      ),
    );
  }
}
