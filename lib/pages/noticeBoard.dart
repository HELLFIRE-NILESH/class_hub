import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoticeBoard extends StatefulWidget {
  const NoticeBoard({super.key});

  @override
  State<NoticeBoard> createState() => _NoticeBoardState();
}

class _NoticeBoardState extends State<NoticeBoard> {
  List<dynamic> notices = [
    {
      'content': 'Notice 1: Meeting at 3 PM tomorrow.',
      'sent_by': 'John Doe',
      'branch': 'CSE',
      'sem': '5',
      'date_time': '2025-01-25T15:30:00',
    },
    {
      'content': 'Notice 2: Submit your assignments by Friday.',
      'sent_by': 'Jane Smith',
      'branch': 'IT',
      'sem': '3',
      'date_time': '2025-01-24T10:00:00',
    },
    {
      'content': 'Notice 3: Attend the workshop on AI.',
      'sent_by': 'Dr. A. Kumar',
      'branch': 'CSE',
      'sem': '7',
      'date_time': '2025-01-23T09:00:00',
    },
    {
      'content': 'Notice 1: Meeting at 3 PM tomorrow.',
      'sent_by': 'John Doe',
      'branch': 'CSE',
      'sem': '5',
      'date_time': '2025-01-25T15:30:00',
    },
    {
      'content': 'Notice 2: Submit your assignments by Friday.',
      'sent_by': 'Jane Smith',
      'branch': 'IT',
      'sem': '3',
      'date_time': '2025-01-24T10:00:00',
    },
    {
      'content': 'Notice 3: Attend the workshop on AI.',
      'sent_by': 'Dr. A. Kumar',
      'branch': 'CSE',
      'sem': '7',
      'date_time': '2025-01-23T09:00:00',
    },
    {
      'content': 'Notice 1: Meeting at 3 PM tomorrow.',
      'sent_by': 'John Doe',
      'branch': 'CSE',
      'sem': '5',
      'date_time': '2025-01-25T15:30:00',
    },
    {
      'content': 'Notice 2: Submit your assignments by Friday.',
      'sent_by': 'Jane Smith',
      'branch': 'IT',
      'sem': '3',
      'date_time': '2025-01-24T10:00:00',
    },
    {
      'content': 'Notice 3: Attend the workshop on AI.',
      'sent_by': 'Dr. A. Kumar',
      'branch': 'CSE',
      'sem': '7',
      'date_time': '2025-01-23T09:00:00',
    },
  ];

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy, hh:mm a').format(date);
    } catch (e) {
      return 'Invalid Date';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reverse the list to ensure the latest notification is at the end
    List<dynamic> reversedNotices = List.from(notices.reversed);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notice Board",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: notices.isEmpty
          ? const Center(
        child: Text(
          "No notices available.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      )
          : ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: reversedNotices.length,
        itemBuilder: (context, index) {
          final notice = reversedNotices[index];
          return Card(
            color: const Color(0xFF193238),
            margin: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice['content'] ?? 'No Content',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sent by: ${notice['sent_by'] ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Branch: ${notice['branch'] ?? 'N/A'}, Sem: ${notice['sem'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formatDateTime(notice['date_time'] ?? ''),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
