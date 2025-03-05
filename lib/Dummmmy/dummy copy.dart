import 'package:flutter/material.dart';

void main() {
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

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RatingSection(),
              SizedBox(height: 16),
              PostPropertySection(),
              SizedBox(height: 16),
              BossPlanSection(),
              SizedBox(height: 16),
              PropertyOfferingsSection(),
              SizedBox(height: 16),
              PopularCitiesSection(),
              SizedBox(height: 16),
              FeedbackSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// 🌟 Rating Section
class RatingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.rate_review, color: Colors.orange),
                SizedBox(width: 8),
                Text("How would you rate your locality / society?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => Icon(Icons.star_border, size: 30, color: Colors.grey),
              ),
            ),
            SizedBox(height: 4),
            Text("Terrible - Excellent", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// 🏡 Post Property Section
class PostPropertySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Register to post your property for",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text("FREE", style: TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Icon(Icons.home, size: 40, color: Colors.blue),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text("Post Property for FREE", style: TextStyle(color: Colors.white)),
            ),
          ),
          SizedBox(height: 8),
          Text("or click here to post via WhatsApp", style: TextStyle(color: Colors.blue, fontSize: 12)),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}

// 💡 Boss Plan Section
class BossPlanSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🔹 You have exhausted your free plan to contact owners"),
            SizedBox(height: 8),
            Text("Introducing BOSS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
            Text("BROKER OWNER SUPPLY SOLUTION"),
            Text("Unlock up to 50 owners contact / month now"),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text("View Plans", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🏠 Property Offerings Section
class PropertyOfferingsSection extends StatelessWidget {
  final List<Map<String, String>> offerings = [
    {"title": "Buy a home", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
    {"title": "Rent a home", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
    {"title": "PG and co-living", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
    {"title": "Buy Plots/Land", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
    {"title": "Buy a commercial property", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
    {"title": "Lease a commercial property", "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT00PFvOqcps9b_nriqfbhmUdoo8gnpSsz6AzmIbaZJ-Ne2sx5H04MAm6E&s"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Check out our offerings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: offerings.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Image.network(offerings[index]['image']!),
              title: Text(offerings[index]['title']!),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            );
          },
        ),
      ],
    );
  }
}

// 🌆 Popular Cities Section
class PopularCitiesSection extends StatelessWidget {
  final List<Map<String, String>> cities = [
    {"name": "Delhi / NCR", "image": "https://via.placeholder.com/80"},
    {"name": "Mumbai", "image": "https://via.placeholder.com/80"},
    {"name": "Bangalore", "image": "https://via.placeholder.com/80"},
    {"name": "Hyderabad", "image": "https://via.placeholder.com/80"},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Explore popular cities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: cities.map((city) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(city['image']!),
                ),
                SizedBox(height: 4),
                Text(city['name']!, style: TextStyle(fontSize: 12)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 😊 Feedback Section
class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Are you finding us helpful?", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Your feedback will help us make Spcode the Best."),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("😊 Yes, Loving it")),
                OutlinedButton(onPressed: () {}, child: Text("😐 No, not really")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
