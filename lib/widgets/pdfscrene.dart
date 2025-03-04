import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class PDFViewerScreen extends StatefulWidget {
  final String url;

  const PDFViewerScreen({super.key, required this.url});

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  String? filePath;
  bool isLoading = true;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/downloaded.pdf');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          filePath = file.path;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error loading PDF')),
        );
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoading
              ? 'Loading PDF...'
              : 'Page ${_currentPage + 1} / $_totalPages',
          style: const TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                filePath = null;
              });
              _downloadAndSavePDF();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : filePath != null
          ? Stack(
        children: [
          Positioned.fill(
            child: PDFView(
              filePath: filePath!,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: true,
              pageSnap: true,
              nightMode: false,
              onRender: (_pages) {
                setState(() {
                  _totalPages = _pages!;
                });
              },
              onViewCreated: (controller) {
                _pdfViewController = controller;
              },
              onPageChanged: (currentPage, _) {
                setState(() {
                  _currentPage = currentPage!;
                });
              },
              onError: (error) {
                print('PDF Error: $error');
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.chevron_right, color: Colors.white),
              onPressed: () async {
                if (_currentPage < _totalPages - 1) {
                  await _pdfViewController?.setPage(_currentPage + 1);
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.chevron_left, color: Colors.white),
              onPressed: () async {
                if (_currentPage > 0) {
                  await _pdfViewController?.setPage(_currentPage - 1);
                }
              },
            ),
          ),
        ],
      )
          : const Center(child: Text('Failed to load PDF')),

    );
  }
}
