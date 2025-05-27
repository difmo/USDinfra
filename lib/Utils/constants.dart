import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppConstants {
  static const List<String> plotAreaUnits = ['SQFT', 'SQYD', 'SQMD'];

  static const List<String> ownershipOptions = [
    'Freehold',
    'Leasehold',
    'Co-operative society',
    'Power of Attorney'
  ];

  static const Map<String, List<String>> availabilityStatusOptions = {
    'Plot/Land': ['Ready to move', 'Under construction', 'Immediately'],
    'default': ['Ready to move', 'Under construction'],
  };

  static const List<String> floorPlanOptions = [
    '2 BHK',
    '3 BHK',
    '4 BHK',
    'Other'
  ];

  static const List<String> bedroomOptions = ['1', '2', '3', '4', '5+'];
  static const List<String> bathroomOptions = ['1', '2', '3', '4', '5+'];
  static const List<String> balconyOptions = [
    '0',
    '1',
    '2',
    '3',
    'More than 3'
  ];
  static const List<String> otherRoomOptions = [
    'Pooja Room',
    'Study Room',
    'Servant Room',
    'Other'
  ];

  static const List<String> PropertyFacing = [
    "East",
    "West",
    "North",
    "South",
    "North East",
    "North West",
    "South East",
    "South West",
  ];
  static const List<String> otherRoomOptions1 = [
    "24 x 7 Security",
    "Road",
    "Park",
    "Water Supply",
    "Electricity",
    "Danety",
    "Clubhouse",
    "Balcony",
    "High Speed Elssevators",
    // "Preschool",
    "Medical Facility",
    "Day Care Center",
    // "Pet Area",
    // "Indoor Games",
    "Conference Room",
    "Large Green Area",
    "Concierge Desk",
    "Helipad",
    // "Golf Course",
    "Multiplex",
    "Visitor's Parking",
    "Serviced Apartments",
    "Service Elevators",
    // "High Street Retail",
    "Hypermarket",
    "ATM'S",
  ];

  static const List<String> propertyAgeOptions = [
    'New',
    '1-5 Years',
    '5-10 Years',
    '10+ Years'
  ];

  static const List<String> facingDirectionOptions = [
    'North',
    'East',
    'South',
    'West',
    'North-East',
    'South-East',
    'North-West',
    'South-West'
  ];

  void launchWhatsApp(String whatsappNumber) async {
    final url = "https://wa.me/$whatsappNumber";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // }
  }

  void makePhoneCall(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // }
  }

  void _callOwner(BuildContext context, String contactDetails) async {
    String phoneNumber = contactDetails;
    phoneNumber = phoneNumber.replaceAll(' ', '');

    final Uri phoneUri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrlString(phoneUri.toString())) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }
}
