import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class PropertyDetailPage extends StatefulWidget {
  final String docId;
  const PropertyDetailPage({super.key, required this.docId});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage>
    with TickerProviderStateMixin {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  bool hasError = false;
  int _currentIndex = 0;
  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _approvalKey = GlobalKey();
  final GlobalKey _addressKey = GlobalKey();

  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  bool showTabs = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _scrollController.addListener(() {
      final offset = _scrollController.offset;
      final shouldShow = offset > 230;
      if (shouldShow != showTabs) {
        setState(() {
          showTabs = shouldShow;
        });
      }

      _updateActiveTab();
    });

    fetchPropertyDetails();
  }

  void _updateActiveTab() {
    final contextMap = {
      0: _overviewKey,
      1: _aboutKey,
      2: _approvalKey,
      3: _addressKey,
    };

    for (int index = 0; index < contextMap.length; index++) {
      final context = contextMap[index]?.currentContext;
      if (context != null) {
        final box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero, ancestor: null).dy;
        if (position <= kToolbarHeight + 60) {
          if (_tabController.index != index) {
            _tabController.animateTo(index);
          }
        }
      }
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (hasError || propertyData == null) {
      return const Scaffold(body: Center(child: Text("Property not found")));
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 250.0,
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {},
                ),
              ],
              flexibleSpace: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed =
                      constraints.biggest.height <= kToolbarHeight + 20;
                  return FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    centerTitle: false,
                    title: isCollapsed
                        ? Text(
                            "${propertyData?['plotArea'] ?? 'N/A'} Sq.Ft. Plot in ${propertyData?['city'] ?? 'N/A'}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                    background: _imageSection(),
                  );
                },
              ),
            ),
            if (showTabs)
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.black,
                    tabs: const [
                      Tab(text: "Overview"),
                      Tab(text: "About Project"),
                      Tab(text: "Approvals"),
                      Tab(text: "Address"),
                    ],
                    onTap: (index) {
                      final contextList = [
                        _overviewKey,
                        _aboutKey,
                        _approvalKey,
                        _addressKey,
                      ][index]
                          .currentContext;

                      if (contextList != null) {
                        Scrollable.ensureVisible(
                          contextList,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${propertyData?['plotArea'] ?? 'N/A'} sq.ft. Plot in ${propertyData?['city'] ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${propertyData?['city'] ?? 'N/A'}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                String city = propertyData?['city'] ?? '';
                                String locality =
                                    propertyData?['locality'] ?? '';
                                String subLocality =
                                    propertyData?['subLocality'] ?? '';
                                final parts = [subLocality, locality, city]
                                    .where((part) => part.isNotEmpty)
                                    .toList();
                                if (parts.isNotEmpty) {
                                  final address = parts.join(', ');
                                  final url = Uri.parse(
                                      'https://www.google.com/maps/search/?q=$address');
                                  launchUrl(url);
                                }
                              },
                              icon: const Icon(
                                Icons.map_outlined,
                                color: Colors.black,
                              ),
                              label: Text(
                                "View on Map",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Rs. ${propertyData?['totalPrice'] ?? "N/A"}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: AppFontFamily.primaryFont,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(key: _overviewKey),
                        _multiAmenitiesSection(
                          "Key Highlights",
                          {
                            "Highlights": [
                              ...List<String>.from(
                                  propertyData?['amenities'] ?? []),
                              ...List<String>.from(
                                  propertyData?['foodcourt'] ?? []),
                            ],
                          },
                        ),
                        _multiAmenitiesSection("Facing and Furnishing", {
                          "Facing":
                              List<String>.from(propertyData?['facing'] ?? []),
                          "Furnishing": List<String>.from(
                              propertyData?['furnishing'] ?? []),
                        }),
                        const SizedBox(height: 16),
                        const Text("Description",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text(
                          propertyData?['description'] ??
                              "No description available.",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 24),
                        Container(key: _aboutKey),
                        Text(
                          "Property Information",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        _sectionCard("Property Overview", [
                          _infoRow("Property For",
                              propertyData?['lookingTo'] ?? 'N/A'),
                          _infoRow("Property Type",
                              propertyData?['propertyType'] ?? 'N/A'),
                          _infoRow("Property Category",
                              propertyData?['propertyCategory'] ?? 'N/A'),
                          _infoRow("Status",
                              propertyData?['availabilityStatus'] ?? 'N/A',
                              highlight: true),
                          _infoRow("City", propertyData?['city'] ?? "N/A"),
                          _infoRow(
                              "Locality", propertyData?['locality'] ?? "N/A"),
                          _infoRow("Sub Locality",
                              propertyData?['subLocality'] ?? "N/A"),
                        ]),
                        Text(
                          "Owner Info",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        _sectionCard("Owner Info", [
                          _infoRow("Ownership Type",
                              propertyData?['ownershipType'] ?? 'N/A'),
                          _infoRow(
                              "Owner", propertyData?['ownerName'] ?? 'N/A'),
                          _infoRow("Contact",
                              propertyData?['contactDetails'] ?? 'N/A'),
                        ]),
                        const SizedBox(height: 8),
                        Container(key: _approvalKey),
                        Text(
                          "Approval Details",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        _sectionCard("Approval Details", [
                          _infoRow("Loan Availability",
                              propertyData?['loanAvailable'] ?? 'N/A'),
                          _infoRow("Govt. Approval",
                              propertyData?['propertyApproved'] ?? 'N/A'),
                          _infoRow(
                              "Rera", propertyData?['reraApproved'] ?? 'N/A'),
                          if ((propertyData?['reraApproved'] ?? '')
                                  .toString()
                                  .toLowerCase() ==
                              'yes')
                            _infoRow("Rera Number",
                                propertyData?['reraNumber'] ?? 'N/A',
                                highlight: true),
                        ]),
                        Container(key: _addressKey),
                        _addressSection(),
                      ],
                    ),
                  ),
                  _bottomPurchaseSection(),
                ],
              ),
            ),
          ],
        ),
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

  Widget _addressSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow1("City", propertyData?['city'] ?? "N/A"),
          _infoRow1("Locality", propertyData?['locality'] ?? "N/A"),
          _infoRow1("Sub Locality", propertyData?['subLocality'] ?? "N/A"),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _bottomPurchaseSection() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: Rs/- ${propertyData?['totalPrice'] ?? 'N/A'}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Buy Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 13,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: highlight ? Colors.green : Colors.black,
        ),
      ),
    ],
  );
}

  Widget _infoRow1(String label, String value, {bool highlight = false}) {
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

  Widget _sectionCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   title,
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // ),
            // const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 56,
              mainAxisSpacing: 12,
              childAspectRatio: 3,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  Widget _multiAmenitiesSection(
      String title, Map<String, List<String>> groupedAmenities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        ...groupedAmenities.entries.map((entry) {
          final amenities = entry.value;

          return amenities.length <= 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Chip(
                      label: Text(
                        amenities.isNotEmpty ? amenities.first : 'N/A',
                      ),
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: amenities.map((amenity) {
                        return Chip(
                          label: Text(
                            amenity,
                          ),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
        }).toList(),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}


// hfdjkfhjkdsfhdjkfhjkdfhdk