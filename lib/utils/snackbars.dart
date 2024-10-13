import 'package:flutter/material.dart';

showSnackBar(context, String message, {String type = "danger"}) {
  var color = const Color.fromARGB(173, 118, 255, 55);
  if (type == "danger") {
    color = const Color.fromARGB(174, 255, 55, 55);
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color,
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
