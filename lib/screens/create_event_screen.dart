import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'display_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final eventNameController = TextEditingController();
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();

  String selectedOccasion = "Birthday";
  int printCopies = 2;
  bool guestUploads = true;
  bool sendGalleryTomorrow = true;

  final List<String> occasions = [
    "Birthday",
    "Wedding",
    "Graduation",
    "Baby Shower",
    "Corporate",
    "Holiday Party",
    "Custom",
  ];

  @override
  Widget build(BuildContext context) {
    final String eventId = DateTime.now().millisecondsSinceEpoch.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Let's set up your event.",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: eventNameController,
              decoration: const InputDecoration(
                labelText: "Event Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedOccasion,
              decoration: const InputDecoration(
                labelText: "Occasion",
                border: OutlineInputBorder(),
              ),
              items: occasions.map((occasion) {
                return DropdownMenuItem(
                  value: occasion,
                  child: Text(occasion),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOccasion = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: customerEmailController,
              decoration: const InputDecoration(
                labelText: "Customer Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Print Copies",
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (printCopies > 0) {
                          setState(() {
                            printCopies--;
                          });
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      "$printCopies",
                      style: const TextStyle(fontSize: 22),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          printCopies++;
                        });
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),

            SwitchListTile(
              title: const Text("Allow Guest Uploads"),
              value: guestUploads,
              onChanged: (value) {
                setState(() {
                  guestUploads = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text("Send Gallery Tomorrow"),
              value: sendGalleryTomorrow,
              onChanged: (value) {
                setState(() {
                  sendGalleryTomorrow = value;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton(
                child: const Text("Continue"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DeviceSelectionScreen(eventId: eventId),
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

class DeviceSelectionScreen extends StatelessWidget {
  final String eventId;

  const DeviceSelectionScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Device"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Which device is this?",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera Station"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraScreen(eventId: eventId),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code),
                label: const Text("Display Station"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DisplayScreen(eventId: eventId),
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