import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import 'create_event_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyBooth"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.photo_camera,
              size: 100,
              color: Colors.deepPurple,
            ),

            const SizedBox(height: 25),

            const Text(
              "Welcome to MyBooth",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Capture Every Memory",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 50),

            PrimaryButton(
              text: "Start New Event",
              icon: Icons.add_circle_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CreateEventScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            PrimaryButton(
              text: "Settings",
              icon: Icons.settings,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}