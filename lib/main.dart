import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'display_screen.dart';
import 'create_event_screen.dart';

void main() {
  runApp(const MyBoothApp());
}

class MyBoothApp extends StatelessWidget {
  const MyBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyBooth',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class EventTheme {
  final String name;
  final IconData icon;
  final Color color;
  final Color background;

  const EventTheme({
    required this.name,
    required this.icon,
    required this.color,
    required this.background,
  });
}

const themes = [
  EventTheme(
    name: "Birthday",
    icon: Icons.cake,
    color: Colors.purple,
    background: Color(0xFFF8F3FF),
  ),
  EventTheme(
    name: "Wedding",
    icon: Icons.favorite,
    color: Color(0xFFD4AF37),
    background: Color(0xFFFFFCF5),
  ),
  EventTheme(
    name: "Graduation",
    icon: Icons.school,
    color: Colors.blue,
    background: Color(0xFFF2F7FF),
  ),
  EventTheme(
    name: "Corporate",
    icon: Icons.business,
    color: Colors.black87,
    background: Color(0xFFF4F4F4),
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  EventTheme selectedTheme = themes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedTheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: selectedTheme.background,
        title: const Text(
          "MyBooth",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: 450,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera,
                  size: 90,
                  color: selectedTheme.color,
                ),

                const SizedBox(height: 20),

                const Text(
                  "MyBooth",
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Capture Every Memory",
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 40),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Choose an Occasion",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: themes.map((theme) {
                    return ChoiceChip(
                      avatar: Icon(theme.icon, size: 18),
                      label: Text(theme.name),
                      selected: selectedTheme == theme,
                      onSelected: (_) {
                        setState(() {
                          selectedTheme = theme;
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Start New Event",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateEventScreen(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.folder_open),
                    label: const Text(
                      "Continue Event",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {},
                  ),
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.settings),
                    label: const Text(
                      "Settings",
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}