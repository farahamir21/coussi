import 'package:flutter/material.dart';
import 'bus_schedule_page.dart'; // Remplacez par le fichier où vous avez défini la page des horaires

class HomePage extends StatelessWidget {
  final TextEditingController startController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bus Finder"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter your starting point and destination",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: startController,
              decoration: InputDecoration(
                labelText: "Start",
                labelStyle: TextStyle(color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "to",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            SizedBox(height: 10),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: "Destination",
                labelStyle: TextStyle(color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange, width: 2),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                String start = startController.text.trim();
                String destination = destinationController.text.trim();

                if (start.isEmpty || destination.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in both fields.")),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusSchedulePage(
                      start: start,
                      destination: destination,
                    ),
                  ),
                );
              },
              child: Text(
                "Search",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.orange),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule, color: Colors.grey),
            label: "Timetable",
          ),
        ],
        selectedItemColor: Colors.orange,
      ),
    );
  }
}
