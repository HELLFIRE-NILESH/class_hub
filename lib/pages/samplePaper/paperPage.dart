
import 'package:class_hub/api_data/userInfo.dart';
import 'package:class_hub/widgets/pdfscrene.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../api_data/dataLoaders.dart';

class PreviousPaper extends StatefulWidget {
  const PreviousPaper({super.key});

  @override
  State<PreviousPaper> createState() => _PreviousPaperState();
}

class _PreviousPaperState extends State<PreviousPaper> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> papers = [];

  @override
  void initState() {
    super.initState();
    _loadPapers();
  }

  Future<void> _loadPapers() async {
    try {
      final user = await loadUserDataFile();
      final List<int> codes = List<int>.from(user[0]['sub']);
      final loadedPapers = await loadSubjectPapers(codes);

      setState(() {
        papers = loadedPapers;
      });
    } catch (e) {
      print('Error loading papers: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Previous Papers"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              searchController.clear();
              _loadPapers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontSize: 18),
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Search paper',
                hintText: 'Search by subject code',
                prefixIcon: const Icon(CupertinoIcons.search),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(CupertinoIcons.clear),
                  onPressed: () {
                    searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: papers.length,
              itemBuilder: (context, index) {
                final subject = papers[index];
                String query = searchController.text.toLowerCase();

                bool matches =
                subject["subjectCode"].toLowerCase().contains(query);

                if (!matches) {
                  return const SizedBox();
                }

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF193238),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${subject["subjectCode"]}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: subject["papers"].length,
                        separatorBuilder: (context, _) => const Divider(),
                        itemBuilder: (context, paperIndex) {
                          final paper = subject["papers"][paperIndex];
                          return ListTile(
                            title: Text(
                              paper["name"],
                              style: const TextStyle(fontSize: 18),
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PDFViewerScreen(url: paper["link"]),
                                  ),
                                );
                              },
                              child: const Text("View"),
                            ),

                          );
                        },
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
