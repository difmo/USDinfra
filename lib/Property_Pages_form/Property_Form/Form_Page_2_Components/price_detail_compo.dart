import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/form_input_field.dart';
import 'package:usdinfra/configs/font_family.dart';

class PriceDetailsSection extends StatelessWidget {
  final TextEditingController pricePerSqftController;
  final TextEditingController totalPriceController;

  const PriceDetailsSection({
    Key? key,
    required this.pricePerSqftController,
    required this.totalPriceController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 20),

        /// Price Per Sqft
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price in Rs/SQFT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
              const SizedBox(height: 8),
              FormTextField(
                controller: pricePerSqftController,
                hint: 'Expected Price in Rs/SQFT',
                borderRadius: 25,
                inputType: TextInputType.phone,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        /// Total Price
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Price in Rs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
              const SizedBox(height: 8),
              FormTextField(
                controller: totalPriceController,
                hint: 'Expected Total Price in Rs',
                borderRadius: 25,
                inputType: TextInputType.phone,
                isEditable:false
              ),
            ],
          ),
        ),
      ],
    );
  }
}
