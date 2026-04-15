import 'package:flutter/material.dart';

void main() {
  runApp(CampusInfoHubApp());
}

class CampusInfoHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Info Hub',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeScreen(),
    );
  }
}

class Facility {
  final String name;
  final String type;
  final String roomNumber;
  final String contact;
  final String hours;
  final String imageUrl;
  bool isBookmarked;

  Facility({
    required this.name,
    required this.type,
    required this.roomNumber,
    required this.contact,
    required this.hours,
    required this.imageUrl,
    this.isBookmarked = false,
  });
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Facility> allFacilities = [
    Facility(
      name: "Physics Lab",
      type: "Lab",
      roomNumber: "B201",
      contact: "012-345-6789",
      hours: "9 AM - 5 PM",
      imageUrl: "https://picsum.photos/seed/lab1/600/300",
    ),
    Facility(
      name: "Computer Science Department",
      type: "Department",
      roomNumber: "D101",
      contact: "cs@college.edu",
      hours: "10 AM - 4 PM",
      imageUrl: "https://picsum.photos/seed/csdept/600/300",
    ),
    Facility(
      name: "Common Room",
      type: "Common Room",
      roomNumber: "A001",
      contact: "admin@college.edu",
      hours: "8 AM - 8 PM",
      imageUrl: "https://picsum.photos/seed/common1/600/300",
    ),
    Facility(
      name: "Chemistry Lab",
      type: "Lab",
      roomNumber: "C103",
      contact: "chem@college.edu",
      hours: "10 AM - 6 PM",
      imageUrl: "https://picsum.photos/seed/chem1/600/300",
    ),
  ];

  String searchQuery = '';
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    List<Facility> filteredFacilities = allFacilities.where((facility) {
      final matchesSearch =
          facility.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter =
          selectedFilter == 'All' || facility.type == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Campus Info Hub'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Lab', child: Text('Lab')),
              PopupMenuItem(value: 'Department', child: Text('Department')),
              PopupMenuItem(value: 'Common Room', child: Text('Common Room')),
            ],
            icon: Icon(Icons.filter_list),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search facilities...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFacilities.length,
              itemBuilder: (context, index) {
                final facility = filteredFacilities[index];
                return FacilityCard(
                  facility: facility,
                  onBookmarkToggle: () {
                    setState(() {
                      facility.isBookmarked = !facility.isBookmarked;
                    });
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class FacilityCard extends StatelessWidget {
  final Facility facility;
  final VoidCallback onBookmarkToggle;

  FacilityCard({required this.facility, required this.onBookmarkToggle});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ExpansionTile(
        leading: Icon(Icons.location_on, color: Colors.indigo),
        title:
            Text(facility.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${facility.type} • Room: ${facility.roomNumber}'),
        trailing: IconButton(
          icon: Icon(
            facility.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: facility.isBookmarked ? Colors.indigo : Colors.grey,
          ),
          onPressed: onBookmarkToggle,
        ),
        children: [
          ListTile(
            title: Text("Contact: ${facility.contact}"),
            subtitle: Text("Hours: ${facility.hours}"),
          ),
          Container(
            padding: EdgeInsets.all(12),
            height: 200,
            width: double.infinity,
            child: Image.network(
              facility.imageUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                return progress == null
                    ? child
                    : Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Text("Image not available"));
              },
            ),
          )
        ],
      ),
    );
  }
}
