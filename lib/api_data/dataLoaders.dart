import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<List<Map<String, dynamic>>> loadData(int sub, String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final subjectDirectory = Directory('${directory.path}/subjects/$sub');
    final file = File('${subjectDirectory.path}/$filename');

    if (await file.exists()) {
      final fileContents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(fileContents);
      print('Loaded data from file: $filename for subject: $sub');
      return List<Map<String, dynamic>>.from(jsonData);
    }
  } catch (e) {
    print('Error loading data from file: $e');
  }
  return [];
}

// You can now call the function for each specific file, like this:
Future<List<Map<String, dynamic>>> assignmentLoader(int sub) => loadData(sub, 'assignment.json');
Future<List<Map<String, dynamic>>> downloadLoader(int sub) => loadData(sub, 'downloads.json');
Future<List<Map<String, dynamic>>> notesLoader(int sub) => loadData(sub, 'notes.json');
Future<List<Map<String, dynamic>>> sitesLoader(int sub) => loadData(sub, 'sites.json');
Future<List<Map<String, dynamic>>> syllabusLoader(int sub) => loadData(sub, 'syllabus.json');


Future<List<Map<String, dynamic>>> loadSubjectPapers(List<int> subjectCodes) async {
  final List<Map<String, dynamic>> loadedPapers = [];
  try {
    final directory = await getApplicationDocumentsDirectory();

    for (int subCode in subjectCodes) {
      final file = File('${directory.path}/subjects/$subCode/paper.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        if (jsonString.trim().isEmpty) {
          print('⚠️ paper.json is empty for subject $subCode');
          continue;
        }
        final List<dynamic> papersList = json.decode(jsonString);

        print('📄 Loaded ${papersList.length} papers for subject $subCode');

        loadedPapers.add({
          "subjectCode": subCode.toString(),
          "papers": papersList,
        });
      } else {
        print('❌ No paper.json found for subject $subCode');
      }
    }
  } catch (e) {
    print('🚨 Error loading papers: $e');
  }
  print('✅ Total subjects with papers: ${loadedPapers.length}');
  return loadedPapers;
}
