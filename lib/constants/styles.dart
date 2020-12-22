import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle whiteTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  shadows: [
    Shadow(color: Colors.grey.shade800, offset: Offset(-2, -2)),
    Shadow(color: Colors.black, blurRadius: 8, offset: Offset(10, 10))
  ],
);
