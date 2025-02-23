import 'dart:ui';
import 'package:flutter/material.dart';

class ExitDialog {
  final bool isLogout;
  final VoidCallback? onLogout;

  ExitDialog({required this.isLogout, this.onLogout});

  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Blur effect
            child: AlertDialog(
              backgroundColor: Colors.white
                  .withValues(alpha: 0.85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                isLogout ? "Logout" : "Exit App",
                style: const TextStyle(
                  fontFamily: "Merriweather",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF193238),
                ),
              ),
              content: Text(
                isLogout
                    ? "Are you sure you want to log out?"
                    : "Are you sure you want to exit?",
                style: const TextStyle(
                  fontFamily: "Merriweather",
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFEDEDF2),
                    backgroundColor: const Color(0xFF193238),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    if (isLogout && onLogout != null) {
                      onLogout!();
                    }
                  },
                  child: Text(
                    isLogout ? "Logout" : "Exit",
                    style: const TextStyle(
                      fontFamily: "Merriweather",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) ??
        false;
  }
}
