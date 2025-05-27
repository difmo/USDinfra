import 'package:flutter/material.dart';
import 'package:usdinfra/Components/Choice_Chip.dart';
import 'package:usdinfra/configs/font_family.dart';

class ChoiceSelectorWidget extends StatefulWidget {
  final String title;
  final List<String> options;
  final bool isMultiSelect;
  final List<String> selectedOptions;
  final void Function(List<String>) onSelectionChanged;

  const ChoiceSelectorWidget({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onSelectionChanged,
    this.isMultiSelect = true,
  });

  @override
  State<ChoiceSelectorWidget> createState() => _ChoiceSelectorWidgetState();
}

class _ChoiceSelectorWidgetState extends State<ChoiceSelectorWidget> {
  late List<String> _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = List.from(widget.selectedOptions);
  }

  void _handleSelect(String option) {
    setState(() {
      if (widget.isMultiSelect) {
        if (_currentSelection.contains(option)) {
          _currentSelection.remove(option);
        } else {
          _currentSelection.add(option);
        }
      } else {
        _currentSelection = [option];
      }
      widget.onSelectionChanged(_currentSelection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: widget.options.map((option) {
            return ChoiceChipOption(
              label: option,
              isSelected: _currentSelection.contains(option),
              onSelected: (_) => _handleSelect(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
