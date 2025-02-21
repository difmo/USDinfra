import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {'title': 'New Message', 'subtitle': 'You have received a new message'},
    {'title': 'Update Available', 'subtitle': 'A new update is ready to install'},
    {'title': 'Reminder', 'subtitle': 'Your meeting is scheduled for 3 PM'},
  ];

  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: Colors.white),),
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),

      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.notifications, color: AppColors.primary),
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['subtitle']!),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
            ),
          );
        },
      ),
    );
  }
}