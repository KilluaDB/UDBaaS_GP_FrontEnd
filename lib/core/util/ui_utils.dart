import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class UiUtils {

  static OverlayEntry? _loadingOverlay;

  static void showLoading(
    BuildContext context, {
    Widget? content,
  }) {
    if (_loadingOverlay != null) return; 

    _loadingOverlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
       
          ModalBarrier(
            dismissible: false,
            color: Colors.black45,
          ),
      
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: content ?? const LoadingIndicator(),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_loadingOverlay!);
  }

  static void hideLoading() {
    _loadingOverlay?.remove();
    _loadingOverlay = null;
  }

  // ------------------ SnackBar Messages ------------------
  static void showSuccessMessage(BuildContext context, String message) {
    _showSnackBar(context, message, AppTheme.green);
  }

  static void showErrorMessage(BuildContext context, String? message) {
    _showSnackBar(context, message ?? "Something went wrong", AppTheme.red);
  }

  static void _showSnackBar(BuildContext context, String message, Color color) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
