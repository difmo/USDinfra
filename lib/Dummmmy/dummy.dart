import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchQuery = "";

  /// Fetch properties based on search query
  Stream<QuerySnapshot> getProperties() {
    return firestore
        .collection('appProperties')
        .where('lookingTo', isGreaterThanOrEqualTo: searchQuery)
        .where('lookingTo', isLessThan: searchQuery + 'z') // Firestore search trick
        .snapshots();
  }

  /// Save search query to Firestore
  void saveSearchQuery(String query) async {
    if (query.isNotEmpty) {
      await firestore.collection('searchHistory').add({'query': query, 'timestamp': DateTime.now()});
      setState(() {
        searchQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        titleSpacing: 0,
        title: Row(
          children: [
            ChoiceChipWidget(label: "Buy", selected: true),
            ChoiceChipWidget(label: "Rent/PG"),
            ChoiceChipWidget(label: "Commercial"),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade900,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Search properties...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onSubmitted: (query) {
                saveSearchQuery(query);
                searchController.clear();
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getProperties(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                var properties = snapshot.data!.docs;
                if (properties.isEmpty) {
                  return Center(child: Text("No properties found."));
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    var data = properties[index].data() as Map<String, dynamic>;
                    return PropertyCard(
                      name: data['name'],
                      location: data['location'],
                      price: data['price'],
                      imageUrl: data['imageUrl'],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Property Card Widget
class PropertyCard extends StatelessWidget {
  final String name, location, price, imageUrl;

  PropertyCard({required this.name, required this.location, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(location, style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 6),
                Text(price, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceChipWidget extends StatelessWidget {
  final String label;
  final bool selected;

  ChoiceChipWidget({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(color: selected ? Colors.blue.shade900 : Colors.white)),
        selected: selected,
        selectedColor: Colors.white,
        backgroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onSelected: (bool value) {},
      ),
    );
  }
}
