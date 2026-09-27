import 'providers/data_providers.dart';
import 'providers/theme_provider.dart';
import 'screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/dashboard_screen.dart';
import 'screens/food_inventory_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/profile_screen.dart';
import 'utils/app_theme.dart';

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
    final themeAsync = ref.watch(themeModeProvider);
    final themeMode = themeAsync.value ?? ThemeMode.system;

    return MaterialApp(
      title: 'Macro Tracker',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.amoledDarkTheme,
      themeMode: themeMode,
      home: themeAsync.isLoading
          ? _ThemeSplash()
          : userAsync.when(
              data: (user) {
                if (user == null) {
                  return const OnboardingScreen();
                }
                return const MainNavigator();
              },
              loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator())),
              error: (err, stack) =>
                  Scaffold(body: Center(child: Text('Error: $err'))),
            ),
    );
  }
}

class _ThemeSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade50,
      body: const Center(
        child: CircularProgressIndicator(color: Colors.green),
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
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const FoodInventoryScreen(),
    const CalendarScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.black,
                systemNavigationBarColor: Colors.black,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness: Brightness.dark,
              ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
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
      ),
    );
  }
}
