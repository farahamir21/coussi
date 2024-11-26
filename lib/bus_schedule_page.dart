import 'package:flutter/material.dart';

class BusSchedulePage extends StatelessWidget {
  final String start;
  final String destination;

  // Constructor to receive start and destination
  BusSchedulePage({required this.start, required this.destination});

  // Dummy data for bus schedules
  final List<Map<String, String>> schedules = [
    {"time": "6:30 AM", "route": "Ben Aknoun - Tafoura"},
    {"time": "7:00 AM", "route": "Ben Aknoun - Tafoura"},
    {"time": "7:30 AM", "route": "Ben Aknoun - Tafoura"},
    {"time": "8:00 AM", "route": "Ben Aknoun - Tafoura"},
    {"time": "8:30 AM", "route": "Ben Aknoun - Tafoura"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Timetable"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bus schedules from $start to $destination",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(Icons.directions_bus, color: Colors.orange, size: 40),
                      title: Text(schedule['time'] ?? '', style: TextStyle(fontSize: 18)),
                      subtitle: Text(schedule['route'] ?? '', style: TextStyle(fontSize: 16)),
                      trailing: Icon(Icons.chat, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.grey),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Colors.orange),
            label: "Timetable",
          ),
        ],
        selectedItemColor: Colors.orange,
      ),
    );
  }
}
