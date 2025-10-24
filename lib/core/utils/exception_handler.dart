import 'dart:io';

import 'package:flutter/services.dart';

enum ExceptionType {
  httpException,
  unknownException,
  platformException;

  @override
  String toString() {
    switch (this) {
      case ExceptionType.httpException:
        return 'Ошибка с сетью.';
      case ExceptionType.platformException:
        return 'Произошла ошибка с платформой.';
      case ExceptionType.unknownException:
        return 'Что-то пошло не так.';
    }
  }
}

class ExceptionHandler {
  final Object exception;

  ExceptionHandler(this.exception);

  ExceptionType getExceptionType() {
    if (exception is HttpException) {
      return ExceptionType.httpException;
    } else if (exception is PlatformException) {
      return ExceptionType.platformException;
    } else {
      return ExceptionType.unknownException;
    }
  }
}
