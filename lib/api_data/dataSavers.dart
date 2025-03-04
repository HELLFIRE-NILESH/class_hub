import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveToFile(int sub, List<dynamic> data, String filename) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final subjectDirectory = Directory('${directory.path}/subjects/$sub');

    if (!await subjectDirectory.exists()) {
      await subjectDirectory.create(recursive: true);
    }

    final file = File('${subjectDirectory.path}/$filename');
    await file.writeAsString(json.encode(data));
    print('Data saved to file: $filename for subject: $sub');
  } catch (e) {
    print('Error saving data to file: $e');
  }
}

// Now, you can call this function for different files:
Future<void> saveAssignments(int sub, List<dynamic> data) => saveToFile(sub, data, 'assignment.json');
Future<void> saveDownloads(int sub, List<dynamic> data) => saveToFile(sub, data, 'downloads.json');
Future<void> saveNotes(int sub, List<dynamic> data) => saveToFile(sub, data, 'notes.json');
Future<void> saveSites(int sub, List<dynamic> data) => saveToFile(sub, data, 'sites.json');
Future<void> saveSyllabus(int sub, List<dynamic> data) => saveToFile(sub, data, 'syllabus.json');
Future<void> savePaper(int sub, List<dynamic> data) => saveToFile(sub, data, 'paper.json');

