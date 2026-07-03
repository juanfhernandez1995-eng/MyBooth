import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../widgets/primary_button.dart';
import 'create_event_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();
    final List<BoothEvent> events = eventProvider.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text("MyBooth"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.photo_camera,
              size: 90,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to MyBooth",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Capture Every Memory",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
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
            const SizedBox(height: 15),
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
            const SizedBox(height: 35),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Events",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: events.isEmpty
                  ? const Center(
                      child: Text(
                        "No events yet.\nCreate your first event!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Icon(
                              Icons.celebration,
                              color: Colors.deepPurple,
                            ),
                            title: Text(event.eventName),
                            subtitle: Text(
                              "${event.occasion} • ${event.displayDate}",
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () {
                                context
                                    .read<EventProvider>()
                                    .deleteEvent(event);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}