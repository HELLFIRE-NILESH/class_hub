import 'package:class_hub/api_data/dataLoaders.dart';
import 'package:class_hub/api_data/dataRefresher.dart';
import 'package:class_hub/theme/themeData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AssignmentPage extends StatefulWidget {
  final int subjectId;

  const AssignmentPage({super.key, required this.subjectId});

  @override
  State<AssignmentPage> createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> filteredAssignments = [];
  bool isRefreshing = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    assignmentLoader(widget.subjectId).then((data) {
      setState(() {
        assignments = data.reversed.toList();
        filteredAssignments = assignments;
      });
    }).catchError((error) {
      print('Error fetching assignments: $error');
    });
  }

  void filterAssignments(String query) {
    setState(() {
      filteredAssignments = assignments.where((assignment) {
        final question = assignment["ques"].toString().toLowerCase();
        final no = assignment["no"].toString().toLowerCase();
        return question.contains(query.toLowerCase()) ||
            no.contains(query.toLowerCase());
      }).toList();
    });
  }

  void copy(ques, no) {
    Clipboard.setData(ClipboardData(text: ques)).then((data) => {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Copied Question no $no"),

            duration: Duration(seconds: 2),
          ))
        });
  }

  void refresh() async {
    setState(() {
      isRefreshing = true;
    });

      try {
        await refreshData(context,widget.subjectId.toString(),"assignment");
        await assignmentLoader(widget.subjectId).then((data)=>{
        setState(() {
        assignments = data.reversed.toList();
        filteredAssignments = assignments;
        isRefreshing = false;
        })
        });

      } catch (error) {
        setState(() {
          isRefreshing =
              false; // Stop showing the loader even if there's an error
        });
        print('Error refreshing assignments: $error');
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments - ${widget.subjectId}'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                refresh();
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Assignments',
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(CupertinoIcons.clear),
                        onPressed: () {
                          searchController.clear();
                          filterAssignments('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: filterAssignments,
            ),
          ),
          isRefreshing
              ? CircularProgressIndicator()
              : filteredAssignments.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'No Assignments Available , Plz connect to college wifi',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: filteredAssignments.length + 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16.0),
                        itemBuilder: (context, index) {
                          if (index == filteredAssignments.length) {
                            // Return an empty space after the last card
                            return const SizedBox(
                                height: 16.0); // Add space after the last card
                          }

                          final assignment = filteredAssignments[index];
                          final question = assignment["ques"];
                          final no = assignment["no"];
                          String formattedDate = '';
                          if (assignment['date_given'] != null) {
                            DateTime dateGiven =
                                DateTime.parse(assignment['date_given']);
                            formattedDate =
                                DateFormat('dd-MM-yyyy').format(dateGiven);
                          }

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                copy(question, no);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                      blurRadius: 6,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Assignment $no",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          const SizedBox(height: 10),
                                          Text(question,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium),
                                          const SizedBox(height: 10),
                                          Text('Date: $formattedDate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    IconButton(
                                      onPressed: () {
                                        copy(question, no);
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.doc_on_clipboard),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
