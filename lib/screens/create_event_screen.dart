import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../services/event_service.dart';
import '../widgets/primary_button.dart';
import 'device_selection_screen.dart';

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
  String selectedLayout = "3-Photo Strip";
  int printCopies = 2;
  bool guestUploadsEnabled = true;
  bool sendGalleryTomorrow = true;

  final occasions = [
    "Birthday",
    "Wedding",
    "Graduation",
    "Baby Shower",
    "Corporate",
    "Holiday",
    "Custom",
  ];

  final layouts = [
    "Single 4x6",
    "2x6 Strip",
    "3-Photo Strip",
    "4 Photo Grid",
  ];

  @override
  void dispose() {
    eventNameController.dispose();
    customerNameController.dispose();
    customerEmailController.dispose();
    super.dispose();
  }

  void createEvent() {
    final event = BoothEvent(
      id: "MB-${DateTime.now().millisecondsSinceEpoch}",
      eventName: eventNameController.text.trim(),
      customerName: customerNameController.text.trim(),
      customerEmail: customerEmailController.text.trim(),
      occasion: selectedOccasion,
      eventDate: DateTime.now(),
      photoLayout: selectedLayout,
      printCopies: printCopies,
      guestUploadsEnabled: guestUploadsEnabled,
      sendGalleryTomorrow: sendGalleryTomorrow,
    );

    context.read<EventService>().addEvent(event);

   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => DeviceSelectionScreen(event: event),
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SizedBox(
            width: 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Let's set up your event.",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: eventNameController,
                  decoration: const InputDecoration(
                    labelText: "Event Name",
                    border: OutlineInputBorder(),
                  ),
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

                DropdownButtonFormField<String>(
                  value: selectedLayout,
                  decoration: const InputDecoration(
                    labelText: "Photo Layout",
                    border: OutlineInputBorder(),
                  ),
                  items: layouts.map((layout) {
                    return DropdownMenuItem(
                      value: layout,
                      child: Text(layout),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLayout = value!;
                    });
                  },
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
                  value: guestUploadsEnabled,
                  onChanged: (value) {
                    setState(() {
                      guestUploadsEnabled = value;
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

                PrimaryButton(
                  text: "Continue",
                  icon: Icons.arrow_forward,
                  onPressed: createEvent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}