import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class RatingSection extends StatefulWidget {
  @override
  _RatingSectionState createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  int _rating = 0;

  void _updateRating(int index) {
    setState(() {
      // Toggle the rating: if clicked on the selected rating, remove it
      if (_rating == index + 1) {
        _rating = 0;  // Reset the rating
      } else {
        _rating = index + 1; // Set the rating
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepOrangeAccent.withOpacity(0.2),
              Colors.redAccent.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    child: Image.asset(
                      'assets/icons/review.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "How would you rate your\nlocality / society?",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () => _updateRating(index),
                          child: Icon(
                            index < _rating ? Icons.star : Icons.star_border,
                            size: 30,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Terrible ",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "Excellent ",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PostPropertySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // Start gradient from top
            end: Alignment.bottomCenter, // End gradient at bottom
            colors: [
              Colors.deepOrangeAccent
                  .withOpacity(0.2), // Lighter blue at the top
              Colors.redAccent.withOpacity(0.2), // Darker blue at the bottom
            ],
          ), // Change background color here
          borderRadius: BorderRadius.circular(10),
        ),
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
                        Text("Register to post your\nproperty for",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Text("FREE",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 90,
                    child: Image.asset(
                      'assets/icons/house.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, // Make button's default background transparent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets
                      .zero, // Remove default padding to apply our custom padding
                ),
                onPressed: () {
                  // Button action
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondry
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                        8), // Same radius as ElevatedButton
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Post Property for FREE",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// 💡 Boss Plan Section
class BossPlanSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepOrangeAccent
                  .withOpacity(0.2), // Lighter orange at the top
              Colors.redAccent.withOpacity(0.2), // Darker red at the bottom
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and description text
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Introducing BOSS",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "BROKER OWNER SUPPLY SOLUTION",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Unlock up to 50 owners \ncontact / month now",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Image.asset(
                        'assets/icons/admin.png', // Replace with your image asset
                        height: 80, // Adjust height as needed
                        width: 90, // Adjust width as needed
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Button to view plans
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors
                      .transparent, // Make button's default background transparent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets
                      .zero, // Remove default padding to apply our custom padding
                ),
                onPressed: () {
                  // Button action
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondry
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                        8), // Same radius as ElevatedButton
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "View Plans",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PropertyOfferingsSection extends StatelessWidget {
  final List<Map<String, String>> offerings = [
    {
      "title": "Buy a home",
      "subtitle": "Find your dream home",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Rent a home",
      "subtitle": "Find a place to rent",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "PG and co-living",
      "subtitle": "Affordable shared living spaces",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Buy Plots/Land",
      "subtitle": "Invest in property",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Buy a commercial property",
      "subtitle": "Grow your business",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Lease a commercial property",
      "subtitle": "Find office spaces to lease",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Check out our offerings",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: offerings.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      offerings[index]['image']!,
                      width: 90,
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(offerings[index]['title']!),
                  subtitle: Text(offerings[index]['subtitle']!),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PopularCitiesSection extends StatelessWidget {
  final List<Map<String, String>> cities = [
    {"name": "Delhi / NCR", "image": "https://via.placeholder.com/80"},
    {"name": "Mumbai", "image": "https://via.placeholder.com/80"},
    {"name": "Bangalore", "image": "https://via.placeholder.com/80"},
    {"name": "Hyderabad", "image": "https://via.placeholder.com/80"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Explore popular cities",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cities.map((city) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(city['image']!),
                      ),
                      SizedBox(height: 4),
                      Text(city['name']!,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepOrangeAccent.withOpacity(0.2),
                Colors.redAccent.withOpacity(0.2),
              ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Are you finding us helpful?",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Your feedback will help us make Spcode the Best."),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {}, child: Text("😊 Yes, Loving it")),
                  OutlinedButton(
                      onPressed: () {}, child: Text("😐 No, not really")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
