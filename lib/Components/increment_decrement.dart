import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class IncrementDecrement extends StatefulWidget {
  final Function(int)? onChanged; // Callback to notify parent of count changes
  final String lable;
  final int initialCount; // Optional initial count

  const IncrementDecrement({
    Key? key,
    this.onChanged,
    this.initialCount = 0,
    required this.lable,
  }) : super(key: key);

  @override
  _IncrementDecrementState createState() => _IncrementDecrementState();
}

class _IncrementDecrementState extends State<IncrementDecrement> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount; // Initialize with provided initial count
  }

  void _increment() {
    setState(() {
      count++;
      widget.onChanged?.call(count); // Notify parent of change
    });
  }

  void _decrement() {
    setState(() {
      if (count > 0) {
        count--;
        widget.onChanged?.call(count); // Notify parent of change
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.lable,
            style: TextStyle(
              fontSize: 16,
              fontFamily: AppFontFamily.primaryFont,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _decrement,
                icon: Icon(
                  Icons.remove,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFontFamily.primaryFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: _increment,
                icon: Icon(
                  Icons.add,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
