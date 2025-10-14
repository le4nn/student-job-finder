import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtension on String {
  String translateToLatin() => toUpperCase()
      .split('')
      .map((char) => _cyrillicToLatin[char] ?? char)
      .join('')
      .toLowerCase()
      .capitalize();

  String get trimmed =>
      trim().replaceAll(" ", "").replaceAll("(", "").replaceAll(")", "");

  bool get isValidPhone => length == 12;

  String get formattedPhone => replaceAll("(", "")
      .replaceAll(")", "")
      .replaceAll("-", "")
      .replaceAll(" ", "");

  String? get onlyDigits => replaceAll(RegExp('[^0-9]'), '');

  double? get latInDouble => double.parse(this);

  double? get longInDouble => double.parse(this);

  bool hasPrefix(String prefix) => substring(0, prefix.length) == prefix;

  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  Color get color =>
      Color(((this).hashCode * 0xFFFFFF).toInt()).withOpacity(0.7);

  String slice(String from, String to) {
    final startIndex = indexOf(from);
    final endIndex = indexOf(to, startIndex + from.length);
    return substring(startIndex + from.length, endIndex);
  }

  String formattedDate({String format = "MMM d HH:mm"}) =>
      DateFormat(format).format(DateTime.parse(this).toLocal());

  List<String> splitText(int chunkSize) {
    List<String> chunks = [];
    for (int i = 0; i < length; i += chunkSize) {
      int end = (i + chunkSize < length) ? i + chunkSize : length;
      chunks.add(substring(i, end));
    }
    return chunks;
  }
}

extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id, bool inplace = true]) {
    final ids = <dynamic>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));
    return list;
  }
}

Map<String, String> _cyrillicToLatin = {
  'А': 'A',
  'Б': 'B',
  'В': 'V',
  'Г': 'G',
  'Д': 'D',
  'Е': 'E',
  'Ё': 'Yo',
  'Ж': 'Zh',
  'З': 'Z',
  'И': 'I',
  'Й': 'Y',
  'К': 'K',
  'Л': 'L',
  'М': 'M',
  'Н': 'N',
  'О': 'O',
  'П': 'P',
  'Р': 'R',
  'С': 'S',
  'Т': 'T',
  'У': 'U',
  'Ф': 'F',
  'Х': 'Kh',
  'Ц': 'Ts',
  'Ч': 'Ch',
  'Ш': 'Sh',
  'Щ': 'Shch',
  'Ъ': '',
  'Ы': 'Y',
  'Ь': '',
  'Э': 'E',
  'Ю': 'Yu',
  'Я': 'Ya'
};
