import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class FloorFormField extends StatefulWidget {
  final ValueChanged<String?>? onFloorSelected; // Callback to update formData
  final String? initialFloor; // Initial floor value from formData
  final String? label;

  const FloorFormField({
    Key? key,
    this.onFloorSelected,
    this.initialFloor,
    this.label,
  }) : super(key: key);

  @override
  _FloorFormFieldState createState() => _FloorFormFieldState();
}

class _FloorFormFieldState extends State<FloorFormField> {
  late String? selectedFloor;

  @override
  void initState() {
    super.initState();
    selectedFloor = widget.initialFloor; // Initialize with formData value
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label ?? "",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showCustomBottomSheet(
              context,
              FloorPicker(
                initialFloor:
                    selectedFloor != null ? int.tryParse(selectedFloor!) : null,
                onFloorSelected: (floor) {
                  setState(() {
                    selectedFloor = floor.toString();
                    widget.onFloorSelected
                        ?.call(selectedFloor); // Update formData
                  });
                },
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              selectedFloor ?? 'Select floor',
              style: TextStyle(
                fontSize: 16,
                color: selectedFloor == null ? Colors.grey : Colors.black,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FloorPicker extends StatelessWidget {
  final int? initialFloor;
  final ValueChanged<int> onFloorSelected;

  const FloorPicker({
    Key? key,
    this.initialFloor,
    required this.onFloorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Floor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 50, // Floors 1 to 50
              itemBuilder: (context, index) {
                final floor = index + 1;
                return ListTile(
                  title: Text(
                    'Floor $floor',
                    style: TextStyle(fontFamily: AppFontFamily.primaryFont),
                  ),
                  onTap: () {
                    onFloorSelected(floor);
                    Navigator.pop(context);
                  },
                  selected: floor == initialFloor,
                  selectedTileColor: Colors.grey[200],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showCustomBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: child,
    ),
  );
}
