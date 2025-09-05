import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  void toggleTheme() {
    setState(() => isDark = !isDark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transaction Dashboard',
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Builder(
        builder: (context) {
          return InheritedThemeToggle(
            toggleTheme: toggleTheme,
            child: const HomePage(),
          );
        },
      ),
    );
  }
}

class InheritedThemeToggle extends InheritedWidget {
  final Function toggleTheme;

  const InheritedThemeToggle(
      {super.key, required this.toggleTheme, required Widget child})
      : super(child: child);

  static InheritedThemeToggle? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedThemeToggle>();
  }

  void changeTheme() => toggleTheme();

  @override
  bool updateShouldNotify(covariant InheritedThemeToggle oldWidget) => true;
}
