import 'package:flutter/material.dart';
import 'package:usdinfra/Userpages/ChatDetailScreen.dart';

import '../Customs/CustomAppBar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title:
          "Chats",),
      // actions: [
      //     IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      //     IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      //   ],
      //   backgroundColor: Colors.white,
      //   elevation: 1,
      // ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          final chat = chatUsers[index];
          return ChatTile(
            name: chat['name'],
            message: chat['message'],
            time: chat['time'],
            unreadCount: chat['unreadCount'],
            profileUrl: chat['profileUrl'],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailScreen(
                    name: chat['name'],
                    profileUrl: chat['profileUrl'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final String profileUrl;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.profileUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: NetworkImage(profileUrl),
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 14,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          if (unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}

final List<Map<String, dynamic>> chatUsers = [
  {
    "name": "John Doe",
    "message": "Hey! How are you?",
    "time": "10:30 AM",
    "unreadCount": 2,
    "profileUrl": "https://randomuser.me/api/portraits/men/1.jpg",
  },
  {
    "name": "Alice Smith",
    "message": "Let's meet up tomorrow.",
    "time": "9:15 AM",
    "unreadCount": 0,
    "profileUrl": "https://randomuser.me/api/portraits/women/2.jpg",
  },
  {
    "name": "Mike Johnson",
    "message": "Check out this new project!",
    "time": "8:45 AM",
    "unreadCount": 5,
    "profileUrl": "https://randomuser.me/api/portraits/men/3.jpg",
  },
];
