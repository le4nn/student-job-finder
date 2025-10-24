import 'package:flutter/material.dart';
import 'package:student_job_finder/core/services/navigation_service.dart';
import 'package:student_job_finder/core/utils/exception_handler.dart';

snackBarBuilder(SnackBarOptions options) {
  String toTitle(final SnackBarType type) {
    switch (type) {
      case SnackBarType.error:
        return 'Ошибка!';
      case SnackBarType.success:
        return 'Успешно!';
      case SnackBarType.defaultType:
        return '';
      case SnackBarType.warning:
        return 'Осторожно!';
    }
  }

  final context = NavigationService.context;
  if (context == null) return;
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + kToolbarHeight,
          left: 10.0,
          right: 10.0),
      content: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Visibility(
            visible: options.hasIcon,
            child: Row(children: [
              Icon(options.type.toIcon(), color: options.type.toForegroundColor()),
              const SizedBox(width: 15)
            ])),
        Expanded(
          child: Text(
            options.type == SnackBarType.error
                ? options.exception?.getExceptionType().toString() ??
                    'Что-то пошло не так.'
                : options.title ?? toTitle(options.type),
            style: TextStyle(color: options.type.toForegroundColor()),
          ),
        ),
        Visibility(
            visible: options.hasClose,
            child: InkWell(
                onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: Icon(Icons.close, color: options.type.toForegroundColor())))
      ]),
      backgroundColor: options.type.backgroundColor(),
      elevation: 12,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5)));
}

enum SnackBarType { success, error, warning, defaultType }

extension _SnackBarTypeX on SnackBarType {
  Color backgroundColor() {
    switch (this) {
      case SnackBarType.defaultType:
        return Colors.black.withOpacity(0.8);
      case SnackBarType.error:
        return const Color(0xFFD32F2F);
      case SnackBarType.success:
        return const Color(0xFF2E7D32);
      case SnackBarType.warning:
        return const Color(0xFFF9A825);
    }
  }

  Color toForegroundColor() {
    switch (this) {
      case SnackBarType.defaultType:
        return Colors.white;
      case SnackBarType.error:
        return Colors.white;
      case SnackBarType.success:
        return Colors.white;
      case SnackBarType.warning:
        return Colors.black;
    }
  }

  IconData toIcon() {
    switch (this) {
      case SnackBarType.defaultType:
        return Icons.info_outline_rounded;
      case SnackBarType.error:
        return Icons.cancel;
      case SnackBarType.success:
        return Icons.check_circle;
      case SnackBarType.warning:
        return Icons.warning;
    }
  }
}

class SnackBarOptions {
  final String? title;
  final ExceptionHandler? exception;
  final SnackBarType type;
  final bool hasIcon;
  final bool hasClose;

  SnackBarOptions({
    this.title,
    this.type = SnackBarType.defaultType,
    this.exception,
    this.hasIcon = true,
    this.hasClose = false,
  });
}
