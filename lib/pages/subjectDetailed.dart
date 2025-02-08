import 'package:class_hub/pages/subjectPages/notesPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/container_widgets/card.dart';
import 'subjectPages/assignmentPage.dart';
import 'subjectPages/docPage.dart';
import 'subjectPages/refPage.dart';
import 'subjectPages/syllabusPage.dart';

class SubDetailed extends StatefulWidget {
  final Map<String, dynamic> subDetail;
  const SubDetailed({super.key, required this.subDetail});

  @override
  State<SubDetailed> createState() => _SubDetailedState();
}

class _SubDetailedState extends State<SubDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subDetail['sub_name']),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: GridView.count(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: [
              buildCard(context, 'Syllabus', Icons.book_outlined, syllabusPage(subjectId: widget.subDetail["sub_code"])),
              buildCard(context, 'Sites', CupertinoIcons.bookmark, refPage(subjectId: widget.subDetail["sub_code"])),
              buildCard(context, 'Assignment', Icons.assignment_outlined, AssignmentPage(subjectId: widget.subDetail["sub_code"])) ,
              buildCard(context, 'Notes', CupertinoIcons.doc_plaintext, NotesPage(subjectId: widget.subDetail['sub_code'])),
              buildCard(context, 'Documents', CupertinoIcons.doc_append, docPage(subjectId: widget.subDetail['sub_code'])),
              buildCard(context, 'Imp', CupertinoIcons.info, Imp()),
            ].map((card) => SizedBox(height: 120, width: 120, child: card)).toList(),
          ),
        ),
      ),
    );
  }
}

class Imp extends StatelessWidget {
  const Imp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Imp')),
      body: Center(child: Text('This is the Imp Page')),
    );
  }
}
