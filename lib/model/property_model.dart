import 'package:cloud_firestore/cloud_firestore.dart';
class PropertyData {
  String? city;
  String? locality;
  String? subLocality;
  String? apartment;
  String? plotArea;
  String? totalFloors;
  String? availabilityStatus;
  String? ownershipType;
  String? expectedPrice;
  bool? allInclusivePrice;
  bool? taxExcluded;
  String? description;

  PropertyData({
    this.city,
    this.locality,
    this.subLocality,
    this.apartment,
    this.plotArea,
    this.totalFloors,
    this.availabilityStatus,
    this.ownershipType,
    this.expectedPrice,
    this.allInclusivePrice,
    this.taxExcluded,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'locality': locality,
      'subLocality': subLocality,
      'apartment': apartment,
      'plotArea': plotArea,
      'totalFloors': totalFloors,
      'availabilityStatus': availabilityStatus,
      'ownershipType': ownershipType,
      'expectedPrice': expectedPrice,
      'allInclusivePrice': allInclusivePrice,
      'taxExcluded': taxExcluded,
      'description': description,
      'createdAt': Timestamp.now(),
    };
  }
}
