import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class UpgradeServiceScreen extends StatefulWidget {
  const UpgradeServiceScreen({super.key});

  @override
  _UpgradeServiceScreenState createState() => _UpgradeServiceScreenState();
}

class _UpgradeServiceScreenState extends State<UpgradeServiceScreen> {
  int selectedServiceIndex = -1; // Track selected service

  final List<Map<String, dynamic>> services = [
    {
      "title": "Basic Construction",
      "description": "Standard materials & labor included",
      "price": "Free",
      "icon": Icons.build,
      "isPremium": false,
    },
    {
      "title": "Premium Construction",
      "description": "High-quality materials & expert workers",
      "price": "\$199/month",
      "icon": Icons.workspace_premium,
      "isPremium": true,
    },
    {
      "title": "Renovation Service",
      "description": "Upgrade your property with modern design",
      "price": "\$299/month",
      "icon": Icons.home_repair_service,
      "isPremium": true,
    },
    {
      "title": "Interior Design",
      "description": "Get a premium modern interior look",
      "price": "\$149/month",
      "icon": Icons.design_services,
      "isPremium": true,
    },
  ];

  void upgradeAccount() {
    if (selectedServiceIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Please select a service to upgrade.",
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        )),
      );
      return;
    }

    final selectedService = services[selectedServiceIndex];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Upgrade to Premium",
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        content: Text(
          "Are you sure you want to upgrade to '${selectedService["title"]}' for ${selectedService["price"]}?",
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondry,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Successfully upgraded to ${selectedService["title"]}!",
                    style: TextStyle(
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              "Upgrade Now",
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Upgrade Services",
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              "Select a construction service to upgrade",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  bool isSelected = selectedServiceIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedServiceIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondry
                              : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            service["icon"],
                            size: 40,
                            color: service["isPremium"]
                                ? Colors.amber
                                : Colors.green,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: service["isPremium"]
                                        ? Colors.black
                                        : Colors.green,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                                Text(
                                  service["description"],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            service["price"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: service["isPremium"]
                                  ? Colors.redAccent
                                  : Colors.green,
                              fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: upgradeAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondry,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(
                "Upgrade Now",
                style: TextStyle(
                  color: AppColors.white,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
