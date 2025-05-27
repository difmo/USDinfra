import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

class LoanAndApprovalSection extends StatefulWidget {
  final TextEditingController reraNumberController;

  const LoanAndApprovalSection({
    super.key,
    required this.reraNumberController,
  });

  @override
  State<LoanAndApprovalSection> createState() => LoanAndApprovalSectionState();
}

class LoanAndApprovalSectionState extends State<LoanAndApprovalSection> {
  String? isLoanAvailable;
  String? isReraApproved;
  String? propertyApproved;

  String? get loanAvailable => isLoanAvailable;
  String? get propertyApprovedStatus => propertyApproved;
  String? get reraApprovedStatus => isReraApproved;
  String get reraNumber => widget.reraNumberController.text.trim();

  Widget _buildRadioOption(
      String label, String? groupValue, Function(String?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(
          value: label,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Loan Available – Checkbox
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Loan Available',
                style: TextStyle(
                    fontFamily: AppFontFamily.primaryFont,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildRadioOption('Yes', isLoanAvailable, (value) {
                    setState(() => isLoanAvailable = value);
                  }),
                  _buildRadioOption('No', isLoanAvailable, (value) {
                    setState(() => isLoanAvailable = value);
                  }),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        /// Property Approved – Radio Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property Approved',
                style: TextStyle(
                    fontFamily: AppFontFamily.primaryFont,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  _buildRadioOption('Yes', propertyApproved, (value) {
                    setState(() => propertyApproved = value);
                  }),
                  _buildRadioOption('No', propertyApproved, (value) {
                    setState(() => propertyApproved = value);
                  }),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        if (propertyApproved == 'Yes')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RERA',
                  style: TextStyle(
                      fontFamily: AppFontFamily.primaryFont,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildRadioOption('Yes', isReraApproved, (value) {
                      setState(() => isReraApproved = value);
                    }),
                    _buildRadioOption('No', isReraApproved, (value) {
                      setState(() => isReraApproved = value);
                    }),
                  ],
                ),
              ],
            ),
          ),

        const SizedBox(height: 16),

        /// RERA Number (Only when RERA is Yes)
        if (isReraApproved == 'Yes')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: widget.reraNumberController,
              decoration: InputDecoration(
                hintText: 'Enter RERA Number',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
