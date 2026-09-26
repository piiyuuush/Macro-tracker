import 'providers/data_providers.dart';
import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/dashboard_screen.dart';
import 'screens/food_inventory_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MacroTrackerApp(),
    ),
  );
}


class MacroTrackerApp extends ConsumerWidget {
  const MacroTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);

    return MaterialApp(
      title: 'Macro Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: userAsync.when(
        data: (user) {
          if (user == null) {
            return const OnboardingScreen();
          }
          return const MainNavigator();
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FoodInventoryScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Colors.green),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.fastfood_outlined),
            selectedIcon: Icon(Icons.fastfood, color: Colors.green),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month, color: Colors.green),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.green),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
