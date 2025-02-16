import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(0),
              const SizedBox(width: 5),
              _buildDot(1),
              const SizedBox(width: 5),
              _buildDot(2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(index * 0.2, 1.0, curve: Curves.easeInOut),
        ),
      ),
      child: const CircleAvatar(
        radius: 4,
        backgroundColor: Colors.black,
      ),
    );
  }
}
