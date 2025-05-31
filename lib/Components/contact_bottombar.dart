import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/configs/app_colors.dart';

class ContactBottombar extends StatefulWidget {
  final String num;
  const ContactBottombar({Key? key, required this.num}) : super(key: key);

  @override
  _ContactBottombarState createState() => _ContactBottombarState();
}

class _ContactBottombarState extends State<ContactBottombar> {
  void _launchWhatsApp() async {
    final url = "https://wa.me/${widget.num}}";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // }
  }

  void _showNumberPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact Number"),
        content: Text(widget.num),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _makePhoneCall() async {
    final url = "tel:${widget.num}";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _launchWhatsApp,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, color: Colors.green),
                  SizedBox(width: 8),
                  Text("WhatsApp", textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => _showNumberPopup(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border.all(color: AppColors.primary, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
              ),
              child: const Text(
                "View Number",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _makePhoneCall,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              border: Border.all(color: AppColors.primary, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            child: const Icon(Icons.call, color: AppColors.white, size: 20),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
