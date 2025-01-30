/// This is a Barrel file containing custom configurations of this app. Import
/// this one file to import all the files from below.
library;

import 'dart:io';

import 'package:dio/dio.dart';

export 'app_components.dart';
export 'app_gaps.dart';
export 'app_images.dart';

///
///
///
String domain = "https://eocsindh.com";
String api = '$domain/api';
String imgpath = '$domain/public/images/';
String recoursepath = '$domain/storage/app/public/Recourses/';
String middleware = 'eoc_8044_750';

Options options = Options(
  headers: {"Content-Type": "application/json"},
);
Options optionsauth = Options(
  headers: {"Content-Type": "application/json", "authenticate": middleware},
);

Options optionsformdata = Options(
  headers: {'Content-Type': 'multipart/form-data'},
);

Options optionsformdataauth = Options(
  headers: {
    HttpHeaders.contentTypeHeader: 'multipart/form-data',
    'authenticate': middleware,
  },
);
