import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';

import 'package:usdinfra/admin/expandable_description.dart';
import 'package:usdinfra/components/contact_bottombar.dart';
import 'package:usdinfra/components/new_enquiry_form.dart';
import 'package:usdinfra/components/property_gallary.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/utils/formatters.dart';

class PropertyDetailPage extends StatefulWidget {
  final String docId;
  const PropertyDetailPage({super.key, required this.docId});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  bool hasError = false;
  int _currentIndex = 0;
  Formatters formatters = new Formatters();

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  final Map<String, IconData> furnishingIcons = {
    "Light": MdiIcons.lightbulb,
    "Fans": MdiIcons.fan,
    "AC": MdiIcons.airFilter,
    "TV": MdiIcons.television,
    "Beds": MdiIcons.bed,
    "Wardrobe": MdiIcons.wardrobe,
    "Geyser": MdiIcons.water,
    "Sofa": MdiIcons.sofa,
    "Washing Machine": MdiIcons.waterAlert,
    "Stove": MdiIcons.stove,
    "Fridge": MdiIcons.fridge,
    "Water Purifier": MdiIcons.waterfall,
    "Microwave": MdiIcons.microwave,
    "Modular Kitchen": MdiIcons.kite,
    "Chimney": MdiIcons.chemicalWeapon,
    "Dining Table": MdiIcons.tableFurniture,
    "Curtains": MdiIcons.curtains,
    "Exhaust Fan": MdiIcons.fan,
  };
  final Map<String, IconData> amenitiesIcons = {
    "24 x 7 Security": MdiIcons.shieldAccount,
    "Road": MdiIcons.roadVariant,
    "Park": MdiIcons.tree,
    "Water Supply": MdiIcons.water,
    "Electricity": MdiIcons.flash,
    "Danety": MdiIcons.toilet, // Assuming sanitation; adjust if needed
    "Clubhouse": MdiIcons.accountGroup,
    "Balcony": MdiIcons.balcony,
    "High Speed Elssevators": MdiIcons.elevatorPassenger,
    "Medical Facility": MdiIcons.hospital,
    "Day Care Center": MdiIcons.babyFaceOutline,
    "Conference Room": MdiIcons.door,
    "Large Green Area": MdiIcons.grass,
    "Concierge Desk": MdiIcons.accountTie,
    "Helipad": MdiIcons.helicopter,
    "Multiplex": MdiIcons.theater,
    "Visitor's Parking": MdiIcons.parking,
    "Serviced Apartments": MdiIcons.domain,
    "Service Elevators": MdiIcons.elevator,
    "Hypermarket": MdiIcons.store,
    "ATM'S": MdiIcons.cashMultiple,
  };

  Future<void> fetchPropertyDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .get();

      if (snapshot.exists) {
        setState(() {
          propertyData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
          print("Property data: $propertyData");
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (hasError || propertyData == null) {
      return const Scaffold(body: Center(child: Text("Property not found")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            const SizedBox(height: 16),
            // _propertyInfoHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        formatters.formatPrice(propertyData?['totalPrice']),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    formatters.capitalizeFirstLetter(
                        propertyData?['title']?.toString() ?? 'N/A'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),

                  Text(
                    "${propertyData?['locality'] ?? "N/A"}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "${propertyData?['propertyType'] ?? 'N/A'} ${propertyData?['propertyCategory'] ?? 'N/A'} ${propertyData?['lookingTo'] ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Facing : ${propertyData?['facing']?.isNotEmpty == true ? propertyData!['facing'][0] : 'N/A'}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          propertyData?['availabilityStatus'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      propertyData?['reraApproved']?.toString().toLowerCase() ==
                              'yes'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "RERA APPROVED",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          6), // Spacing between text and icon
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// there icon for property type and second icon for rupeess

                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.house,
                                  color: Colors.blue, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${propertyData?['plotArea'] ?? 'N/A'} sqft",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Plot Area",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 25),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.currency_rupee,
                                  color: Colors.orange, size: 20),
                            ),
                            Text(
                              "${(propertyData?['expectedPrice'] as String?)?.replaceAll(RegExp(r'\s*SQFT', caseSensitive: false), '') ?? 'N/A'} Price",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "per sq.ft.",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (propertyData?['propertyCategory'] == "Apartment")
                    _propertyInfoHeader(),

                  _sectionCard("Approval Details", [
                    _infoRow("Loan Availability",
                        propertyData?['loanAvailable'] ?? 'N/A'),
                    _infoRow("Govt. Approval",
                        propertyData?['propertyApproved'] ?? 'N/A'),
                    if ((propertyData?['reraApproved'] ?? '')
                            .toString()
                            .toLowerCase() ==
                        'no')
                      _infoRow("Rera", propertyData?['reraApproved'] ?? 'N/A'),
                    if ((propertyData?['reraApproved'] ?? '')
                            .toString()
                            .toLowerCase() ==
                        'yes')
                      _infoRow(
                          "Rera Number", propertyData?['reraNumber'] ?? 'N/A',
                          highlight: true),
                  ]),
                  Container(
                    child: Text(
                      "Property Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        propertyDetailRow('Ownership',
                            '${propertyData?['ownershipType'] ?? 'N/A'}'),
                        propertyDetailRow('Plot Area',
                            '${propertyData?['plotArea'] ?? 'N/A'} sqft'),
                        propertyDetailRow(
                            'Length', '${propertyData?['length'] ?? 'N/A'} Ft'),
                        propertyDetailRow('Breadth',
                            '${propertyData?['breadth'] ?? 'N/A'} Ft'),
                        propertyDetailRow('Property Approved',
                            '${propertyData?['propertyApproved'] ?? 'N/A'}'),
                        propertyDetailRow(
                            'facing', '${propertyData?['facing'] ?? 'N/A'}'),
                        propertyDetailRow('No. of Open Sides',
                            '${propertyData?['noOfOpenSides'] ?? 'N/A'}'),
                        if (propertyData?['propertyCategory'] != "Plot/Land")
                          Divider(),

                        if (propertyData?['propertyCategory'] != "Plot/Land")
                          Column(
                            children: [
                              propertyDetailRow('Covered Parking',
                                  '${propertyData?['coveredparking'] ?? 'N/A'}'),
                              propertyDetailRow('Open Parking',
                                  '${propertyData?['openparking'] ?? 'N/A'}'),
                              propertyDetailRow('Balconies',
                                  '${propertyData?['balconies'] ?? 'N/A'}'),
                              propertyDetailRow('Other Rooms',
                                  '${propertyData?['otherRooms'] ?? 'N/A'}'),
                              propertyDetailRow('Furnishing',
                                  '${propertyData?['furnishing'] ?? 'N/A'}'),
                            ],
                          ),
                        // _addressSection(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //_addressSection(),
                  if (propertyData?['propertyCategory'] != "Plot/Land")
                    if (propertyData?['furnishingDetails'] != null &&
                        propertyData?['furnishingDetails'] is List &&
                        (propertyData?['furnishingDetails'] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Furnishing Details:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          GridView.count(
                            crossAxisCount: 4, // 2 columns
                            shrinkWrap:
                                true, // Prevent GridView from taking infinite height
                            physics:
                                const NeverScrollableScrollPhysics(), // Disable scrolling
                            childAspectRatio: 1, // Adjusted for vertical layout
                            mainAxisSpacing: 8, // Spacing between rows
                            crossAxisSpacing: 8, // Spacing between columns
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            children: (propertyData?['furnishingDetails']
                                    as List)
                                .map(
                                  (item) => Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Center items vertically
                                    children: [
                                      Icon(
                                        furnishingIcons[item] ??
                                            Icons.check_circle,
                                        color: Colors.red,
                                        size: 28,
                                      ),
                                      const SizedBox(
                                          height:
                                              4), // Spacing between icon and text
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(fontSize: 16),
                                          overflow: TextOverflow
                                              .ellipsis, // Handle long text
                                          textAlign: TextAlign
                                              .center, // Center text horizontally
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),

                  _multiAmenitiesSection(
                    "Available Amenities",
                    {
                      "Amenities":
                          List<String>.from(propertyData?['amenities'] ?? []),
                    },
                    amenitiesIcons,
                  ),

                  PropertyGallery(
                    imageUrls: propertyData?['imageUrl'] ?? [],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ExpandableDescription(
                      description: propertyData?['description'] ??
                          "No description available."),
                  const SizedBox(height: 24),

                  Container(
                    child: Text(
                      propertyData?['dealerType'] == null
                          ? "Contact N/A"
                          : "Contact ${propertyData?['dealerType']}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _sectionCard("Owner Info", [
                    // _infoRow("Ownership Type",
                    //     propertyData?['ownershipType'] ?? 'N/A'),
                    _infoRow("Owner", propertyData?['ownerName'] ?? 'N/A'),
                    _infoRow(
                        "Contact", propertyData?['contactDetails'] ?? 'N/A'),
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 16,
            ),
            // _bottomPurchaseSection(),
            NewEnquiryForm(
                propertyId: widget.docId, propertyData: propertyData),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: ContactBottombar(num: propertyData?['contactDetails'])),
    );
  }

  Widget _propertyInfoHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Icon(Icons.home),
              Text("${propertyData?['floorPlan'] ?? 'N/A'} ")
            ],
          ),
          Column(
            children: [
              const Icon(Icons.bed),
              Text("${propertyData?['bedrooms'] ?? 'N/A'} Beds")
            ],
          ),
          Column(
            children: [
              const Icon(Icons.bathroom),
              Text("${propertyData?['bathrooms'] ?? 'N/A'} Baths")
            ],
          ),
          Column(
            children: [
              const Icon(Icons.vertical_align_top_rounded),
              Text("${propertyData?['plotArea'] ?? 'N/A'} sqft")
            ],
          ),
        ],
      ),
    );
  }

  Widget propertyDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageSection() {
    List<dynamic> imageUrls = propertyData?['imageUrl'] ?? [];

    if (imageUrls.isEmpty) {
      imageUrls = [
        "https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg"
      ];
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_currentIndex + 1}/${imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionCard(String title, List<Widget> children,
      {bool isGrid = false}) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(title,
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 12),
            isGrid
                ? Wrap(spacing: 16, runSpacing: 12, children: children)
                : Column(children: children),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: highlight ? Colors.green : null)),
        ],
      ),
    );
  }

  Widget _multiAmenitiesSection(
    String title,
    Map<String, List<String>> groupedAmenities,
    Map<String, IconData> iconsMap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: _sectionCard(
        title,
        groupedAmenities.entries.map((entry) {
          final amenities = entry.value;

          return amenities.length <= 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      label:
                          Text(amenities.isNotEmpty ? amenities.first : 'N/A'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: amenities.map((amenity) {
                        return Chip(
                          backgroundColor: Colors.grey[200],
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                iconsMap[amenity] ??
                                    Icons.check_circle_outline, // fallback icon
                                size: 22,
                                color: const Color.fromARGB(255, 100, 123, 255),
                              ),
                              const SizedBox(width: 6),
                              Text(amenity),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    // const SizedBox(height: 16),
                  ],
                );
        }).toList(),
        isGrid: false,
      ),
    );
  }
}
