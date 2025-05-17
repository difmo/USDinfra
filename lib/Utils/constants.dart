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
}
