import 'package:flutter/material.dart';
import 'package:usdinfra/Userpages/offering_page.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class RatingSection extends StatefulWidget {
  @override
  _RatingSectionState createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  int _rating = 0;

  void _updateRating(int index) {
    setState(() {
      if (_rating == index + 1) {
        _rating = 0;
      } else {
        _rating = index + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: const EdgeInsets.all(10.0),
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
          padding: EdgeInsets.all(6),
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
                        fontFamily: AppFontFamily.primaryFont,
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
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                          Text(
                            "Excellent ",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: AppFontFamily.primaryFont,
                            ),
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
              padding: EdgeInsets.all(6),
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
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFontFamily.primaryFont,
                            )),
                        SizedBox(height: 10),
                        Text("FREE",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFontFamily.primaryFont,
                            )),
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
                  Navigator.pushNamed(context, AppRouts.propertyform1);
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
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
          padding: EdgeInsets.all(10),
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
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "BROKER OWNER SUPPLY SOLUTION",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: AppFontFamily.primaryFont,
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
                          fontFamily: AppFontFamily.primaryFont,
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
                  Navigator.pushNamed(context, AppRouts.upgardeservice);
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
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
      "title": "Sell",
      "subtitle": "Find your dream home",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Rent / Lease",
      "subtitle": "Find a place to rent",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Paying Guest",
      "subtitle": "Affordable shared living spaces",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Plot/Land",
      "subtitle": "Invest in property",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    {
      "title": "Commercial",
      "subtitle": "Grow your business",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    },
    // {
    //   "title": "Lease a commercial property",
    //   "subtitle": "Find office spaces to lease",
    //   "image":
    //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCPbIuCb6AtjrZ1M9ARi6elvNiPkI1D6CtOtsN0e-4MxDsaymlo6c-wok&s"
    // },
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: offerings.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the DetailPage when the container is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        title: offerings[index]['title']!,
                        subtitle: offerings[index]['subtitle']!,
                        imageUrl: offerings[index]['image']!,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 65,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                          child: Image.network(
                            offerings[index]['image']!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 12),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          offerings[index]['title']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily:
                                                AppFontFamily.primaryFont,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          offerings[index]['subtitle']!,
                                          style: TextStyle(
                                            fontFamily:
                                                AppFontFamily.primaryFont,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(thickness: 1, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class PopularCitiesSection extends StatelessWidget {
  final List<Map<String, String>> cities = [
    {
      "name": "Delhi / NCR",
      "image":
          "https://images.pexels.com/photos/14520365/pexels-photo-14520365.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
    },
    {
      "name": "Mumbai",
      "image":
          "https://images.pexels.com/photos/31016952/pexels-photo-31016952/free-photo-of-the-taj-mahal-palace-hotel-in-mumbai-at-twilight.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2"
    },
    {
      "name": "Bangalore",
      "image":
          "https://as1.ftcdn.net/jpg/03/41/95/04/1000_F_341950409_Gq1sN2OqYgRZrUTvPohSmgQVubaqzlA5.webp"
    },
    {
      "name": "Hyderabad",
      "image":
          "https://as2.ftcdn.net/jpg/00/47/49/01/1000_F_47490128_JLClMTbZyVdxl3OW2m8H4vJHW7hDZ8Jj.webp"
    },
    {
      "name": "Pune",
      "image":
          "https://media.istockphoto.com/id/1257407227/photo/isolated-image-of-shree-swaminarayan-temple-ambegaon-pune-maharashtra-india.jpg?s=612x612&w=0&k=20&c=na15RawnI9ALfi63h9Je9li_e5y139jABmkyt5MMhVU="
    },
    {
      "name": "Kolkata",
      "image":
          "https://media.istockphoto.com/id/1164386039/photo/howrah-bridge-on-river-ganges-at-kolkata-at-twilight-with-moody-sky.jpg?s=612x612&w=0&k=20&c=CHrNWdInFSDyERdvgd0f8935hZcBQU6lbYCE4LlXqUY="
    },
    {
      "name": "Chennai",
      "image":
          "https://media.istockphoto.com/id/1226340114/photo/puratchi-thalaivar-dr-mgr-central-railway-station-chennai-central-railway-station-india.jpg?s=612x612&w=0&k=20&c=lZjBnWBBoLiApWZUUWP1Vl3XAVdKjYMcgGpItXv_L14="
    },
    {
      "name": "Ahmedabad",
      "image":
          "https://plus.unsplash.com/premium_photo-1697729749187-ec80a3f41969?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Explore popular cities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              )),
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cities.map((city) {
                return Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(city['image']!),
                      ),
                      SizedBox(height: 4),
                      Text(city['name']!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFontFamily.primaryFont,
                          )),
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  )),
              SizedBox(height: 5),
              Text(
                "Your feedback will help us make USDuniue the Best.",
                style: TextStyle(
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                            child: Text(
                          '😊',
                          style: TextStyle(fontSize: 40),
                        )),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Yes, Loving it",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      )
                    ],
                  ),
                  // ElevatedButton(
                  //     onPressed: () {}, child: Text("😊 Yes, Loving it")),
                  // OutlinedButton(
                  //     onPressed: () {}, child: Text("😐 No, not really")),
                  Column(
                    children: [
                      Container(
                        height: 80,
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                            child: Text(
                          '😐',
                          style: TextStyle(fontSize: 40),
                        )),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No, not really",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
