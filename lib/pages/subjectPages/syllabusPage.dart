import 'package:class_hub/api_data/dataLoaders.dart';
import 'package:class_hub/api_data/dataRefresher.dart';
import 'package:flutter/material.dart';
class syllabusPage extends StatefulWidget {
  final int subjectId;
  const syllabusPage({super.key, required this.subjectId});

  @override
  State<syllabusPage> createState() => _syllabusPageState();
}

class _syllabusPageState extends State<syllabusPage> {
  List<Map<String, dynamic>> syllabus = [];
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredSyllabus = [];
  bool isRefreshing = true;
  @override
  void initState() {
    super.initState();
    syllabusLoader(widget.subjectId).then((data) {
      setState(() {
        isRefreshing = false;
        syllabus = data;
        filteredSyllabus = syllabus;
      });
    }).catchError((error) {
      setState(() {
        isRefreshing = false;
      });
      print('Error fetching syllabus: $error');
    });

    _searchController.addListener(() {
      _searchSyllabus(_searchController.text);
    });
  }

  void _searchSyllabus(String query) {
    final filtered = syllabus.where((unit) {
      return unit['content'].toLowerCase().contains(query.toLowerCase()) ||
          unit['unit_no'].toString().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSyllabus = filtered;
    });
  }

  // Clear search function
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredSyllabus = syllabus;
    });
  }


  void refresh() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      await refreshData(context,widget.subjectId.toString(),"downloads");
      await syllabusLoader(widget.subjectId).then((data)=>{
        setState(() {
          syllabus = data;
          filteredSyllabus = syllabus;
          isRefreshing = false;
        })
      });

    } catch (error) {
      setState(() {
        isRefreshing =
        false;
      });
      print('Error refreshing assignments: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Syllabus"),
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
          // Permanent search bar below AppBar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                labelText: 'Search Syllabus',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _clearSearch,
                      )
                    : null,
              ),
            ),
          ),
          isRefreshing
              ? CircularProgressIndicator()
              : filteredSyllabus.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        'No syllabus Available , Plz connect to college wifi',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredSyllabus.length,
                        itemBuilder: (context, index) {
                          final unit = filteredSyllabus[index];
                          final content = unit['content'] as String;

                          final contentParts =
                              content.split(RegExp(r'[;]')).map((part) {
                            return part.trim();
                          }).toList();

                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF193238),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      )

                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.all(10.0),
                                    child: Text('Unit ${unit['unit_no']}',
                                        style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white

                                    ),),
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: contentParts.map((part) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                4.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('• ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            Expanded(
                                                child: Text('$part.',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium)),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
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
