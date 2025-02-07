import 'package:class_hub/pages/subjectDetailed.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final Map<String, dynamic> subdata;

  const SubjectCard({
    super.key,
    required this.subdata,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubDetailed(subDetail: subdata),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        decoration: BoxDecoration(
          color: Color(0xFF1E4D4D),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                "assets/images/ds.jpg",
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subdata['sub_name'] ?? 'Unknown Subject',
                    style: Theme.of(context).textTheme.titleSmall
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subdata['teacher_name'] ?? 'Unknown Teacher',
                    style: Theme.of(context).textTheme.labelMedium,

                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectList extends StatelessWidget {
  final List<dynamic> sub;

  const SubjectList({super.key, required this.sub});

  Future<List<Widget>> _getSubjectCards(List<dynamic> sub) async {
    List<Widget> subjectWidgets = [];
    for (var subject in sub) {
      if (subject is Map<String, dynamic>) {
        subjectWidgets.add(SubjectCard(subdata: subject));
      }
    }
    return subjectWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Widget>>(
      future: _getSubjectCards(sub),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: snapshot.data ?? [],
            ),
          );
        }
      },
    );
  }
}
