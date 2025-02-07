import 'package:class_hub/pages/subjectPages/assignmentPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignmentCard extends StatelessWidget {
  final String title;
  final String lastdate;
  final VoidCallback onTap;

  const AssignmentCard({
    super.key,
    required this.title,
    required this.lastdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          constraints: const BoxConstraints(
            minWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),

          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEDED),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF193238),
                  )
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  size: 28,
                  color: Color(0xFF193238),
                ),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Submit date: $lastdate",
                    style: Theme.of(context).textTheme.labelSmall
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentList extends StatelessWidget {
  final List<dynamic> sub;

  const AssignmentList({super.key, required this.sub});

  Future<List<Widget>> _getAssignmentCards(BuildContext context, List<dynamic> sub) async {
    List<Widget> assignmentWidgets = [];
    var subjectData = sub;

    for (var subject in subjectData) {
      String title = subject['sub_name'];
      String formattedDate = '';
      if (subject['last_date'] != null) {
        DateTime dateGiven = DateTime.parse(subject['last_date']);
        formattedDate = DateFormat('dd-MM-yyyy').format(dateGiven);
      }

      assignmentWidgets.add(AssignmentCard(
        title: title,
        lastdate: formattedDate,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AssignmentPage(
                subjectId: subject['sub_code'],  // Pass the subject ID dynamically
              ),
            ),
          );
        },
      ));
    }
    return assignmentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _getAssignmentCards(context, sub),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }   else {
          return Column(
            children: snapshot.data!,
          );
        }
      },
    );
  }
}
