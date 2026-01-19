import 'package:dbaas_project/core/app_theme.dart';
import 'package:dbaas_project/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiUtils {
  static void showLoading(
    BuildContext context, {
    Widget? content,
    bool? canPop,
  }) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: canPop ?? false,
      child: AlertDialog(
        content: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.2,
          child:
              content ??
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [LoadingIndicator()],
              ),
        ),
      ),
    ),
  );

  static void hideLoading(BuildContext context) => Navigator.of(context).pop();

  static void showSuccessMessage(String message) => Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: AppTheme.green,
    textColor: AppTheme.white,
  );
  static void showErrorMessage(String? message) => Fluttertoast.showToast(
    msg: message ?? "Something Went Wrong",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: AppTheme.red,
    textColor: AppTheme.white,
  );
}
