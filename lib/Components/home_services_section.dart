import 'package:flutter/material.dart';
import 'dart:async';
import 'inquiry_form.dart';

class HomeServicesSection extends StatefulWidget {
  const HomeServicesSection({super.key});

  @override
  State<HomeServicesSection> createState() => _HomeServicesSectionState();
}

class _HomeServicesSectionState extends State<HomeServicesSection> {
  final List<String> sliderImages = [
    "assets/images/slide1.jpeg",
    "assets/images/slide2.jpeg",
    "assets/images/slide3.jpeg",
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < sliderImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Everything you need at services",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            children: [
              ServiceItem(
                title: "Home Painting",
                imagePath: "assets/images/home_painting.jpeg",
                borderColor: Color.fromARGB(255, 247, 113, 3),
              ),
              ServiceItem(
                title: "Home Loan",
                imagePath: "assets/images/home_loan.jpeg",
                borderColor: Color.fromARGB(255, 27, 3, 247),
              ),
              ServiceItem(
                title: "Construction",
                imagePath: "assets/images/construction.jpeg",
                borderColor: Color.fromARGB(255, 247, 113, 3),
              ),
              ServiceItem(
                title: "Legal",
                imagePath: "assets/images/legal.jpeg",
                borderColor: Color.fromARGB(255, 27, 3, 247),
              ),
            ],
          ),
          const Text(
            "New Launches",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(sliderImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color borderColor;

  const ServiceItem({
    super.key,
    required this.title,
    required this.imagePath,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InquiryForm(serviceName: title),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
