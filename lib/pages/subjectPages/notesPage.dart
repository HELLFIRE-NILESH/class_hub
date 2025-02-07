import 'package:class_hub/api_data/dataLoaders.dart';
import 'package:class_hub/api_data/dataRefresher.dart';
import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  final int subjectId;

  const NotesPage({super.key, required this.subjectId});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Map<String, dynamic>> notes = [];
  List<Map<String, dynamic>> filteredNotes = [];
  final TextEditingController _searchController = TextEditingController();
  bool isRefreshing = true;

  @override
  void initState() {
    super.initState();
    notesLoader(widget.subjectId).then((data) {
      setState(() {
        isRefreshing = false;
        notes = data;
        filteredNotes = notes;
      });
    }).catchError((error) {
      setState(() {
        isRefreshing = false;
      });
      print('Error fetching notes: $error');
    });

    _searchController.addListener(() {
      _searchNotes(_searchController.text);
    });
  }

  // Method to parse bold text (between '**') in content
  TextSpan _parseBoldText(String text) {
    List<TextSpan> spans = [];
    RegExp exp = RegExp(r'(\*\*([^*]+)\*\*)'); // Regex to find bold text between '**'
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    int lastMatchEnd = 0;
    for (var match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(2), // Text between '**' to be bold
        style: TextStyle(fontSize: 17,        fontFamily: "Merri",
            fontWeight: FontWeight.bold),
      ));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return TextSpan(children: spans);
  }

  // Search function to filter notes based on unit number or topic
  void _searchNotes(String query) {
    final filtered = notes.where((note) {
      // Check if the unit or topic contains the search query or the query without '-'
      String queryWithoutDash = query.replaceAll('-', '').toLowerCase();
      return note['unit'].toString().toLowerCase().contains(queryWithoutDash) ||
          note['topic'].toLowerCase().contains(queryWithoutDash);
    }).toList();

    setState(() {
      filteredNotes = filtered;
    });
  }

  // Clear search function
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      filteredNotes = notes;
    });
  }


  void refresh() async {
    setState(() {
      isRefreshing = true;
    });

    try {
      await refreshData(context,widget.subjectId.toString(),"notes");
      await notesLoader(widget.subjectId).then((data)=>{
        setState(() {
          notes = data;
          filteredNotes = notes;
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
        title: Text("Notes"),
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
              controller: _searchController,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal
              ),
              decoration: InputDecoration(
                labelText: 'Search Topics',
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
              ? Center(child: CircularProgressIndicator())
              : filteredNotes.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'No notes found for your search.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          )
              : Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];

                return Card(

                  borderOnForeground: true,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note['topic'],
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        SizedBox(height: 12),
                        Text.rich(
                          _parseBoldText(note['content']),
                          style: TextStyle(
                            fontSize: 16,
                            wordSpacing: 2
                          ),
                        ),
                      ],
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
