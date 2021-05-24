import 'package:flutter/material.dart';

class RespondFields {
  final String fileName;
  final String base64Image;
  RespondFields({@required this.fileName, @required this.base64Image});
  String get name => fileName;
  String get data => base64Image;
}
