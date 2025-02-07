import 'package:flutter/material.dart';

class BacklogCard extends StatelessWidget {
  static const Color primaryColor = Color(0xFF193238);

  final List<dynamic> backLogs;

  const BacklogCard({super.key, required this.backLogs});

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width - 40;

    return backLogs.isEmpty
        ? SizedBox.shrink() // If there are no backlogs, return an empty widget
        : SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Backlogs",
                style: Theme.of(context).textTheme.titleLarge
              ),
              const SizedBox(height: 8),
              Text(
                "You have ${backLogs.length} backlog(s).",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...backLogs.map(
                    (subjectCode) => Text(
                  "Subject Code: $subjectCode",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Keep working hard, you'll overcome them!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
