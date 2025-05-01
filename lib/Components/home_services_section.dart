import 'package:flutter/material.dart';

class HomeServicesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Home Services",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "See All",
                style: TextStyle(
                    fontSize: 14, color: Colors.green, fontWeight: FontWeight.w600),
              )
            ],
          ),
          SizedBox(height: 16),

          /// Top Horizontal Cards
          // SizedBox(
          //   height: 160,
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: [
          //       TopServiceCard(
          //         width: cardWidth,
          //         imageUrl: 'https://via.placeholder.com/300x160',
          //         title: "Packers & Movers",
          //         offer: "UPTO 20% OFF",
          //       ),
          //       SizedBox(width: 12),
          //       TopServiceCard(
          //         width: cardWidth,
          //         imageUrl: 'https://via.placeholder.com/300x160',
          //         title: "AC Service & Repair",
          //         offer: "UPTO 20% OFF",
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 24),

          /// Grid-style services
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              ServiceItem(title: "Home Cleaning", icon: Icons.cleaning_services),
              ServiceItem(title: "Home Painting", icon: Icons.format_paint),
              ServiceItem(title: "Legal Service", icon: Icons.assignment),
              ServiceItem(title: "Interier Design", icon: Icons.payments),
            ],
          ),
        ],
      ),
    );
  }
}

class TopServiceCard extends StatelessWidget {
  final double width;
  final String imageUrl;
  final String title;
  final String offer;

  const TopServiceCard({
    required this.width,
    required this.imageUrl,
    required this.title,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                offer,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const ServiceItem({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6, offset: Offset(0, 3)),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.deepOrange),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
