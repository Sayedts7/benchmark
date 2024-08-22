import 'package:benchmark_estimate/utils/constants/colors.dart';
import 'package:benchmark_estimate/view_model/firebase/firebase_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String projectId;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  ChatScreen({required this.projectId});

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Messages')
                  .where('projectId', isEqualTo: projectId)
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final messages = snapshot.data!.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
                // Scroll to bottom when messages are fetched
                WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ChatBubble(message: message);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Send a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      final message = ChatMessage(
                        message: _controller.text,
                        timestamp: DateTime.now(),
                        isSender: true,
                        projectId: projectId,
                      );
                      await FirebaseFirestore.instance.collection('Messages').add(message.toFirestore());
                      await FirestoreService().setNotifications('admin', 'New Message', _controller.text, projectId);
                      _controller.clear();
                      // Scroll to bottom when a new message is sent
                      _scrollToBottom();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isSender) CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: message.isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: message.isSender ? primaryColor : Color(0xffF2F4F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.message,
                  style: TextStyle(color: message.isSender ? whiteColor : blackColor),
                ),
              ),
              SizedBox(height: 5),
              Text(
                '${message.timestamp.hour}:${message.timestamp.minute}',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          if (message.isSender) CircleAvatar(child: Icon(Icons.person)),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String message;
  final DateTime timestamp;
  final bool isSender;
  final String projectId;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.isSender,
    required this.projectId,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatMessage(
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isSender: data['isSender'] ?? true,
      projectId: data['projectId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'message': message,
      'timestamp': timestamp,
      'isSender': isSender,
      'projectId': projectId,
    };
  }
}
