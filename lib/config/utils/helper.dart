
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();


String formatDateDetails(String dateString) {
  try {
    final normalized = dateString.replaceFirst(' ', 'T');
    final date = DateTime.parse(normalized);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  } catch (_) {
    return dateString; // fallback seguro
  }
}

String formatDate(String isoDate) {
  final date = DateTime.parse(isoDate);
  return DateFormat('dd/MM/yyyy HH:mm').format(date);
}