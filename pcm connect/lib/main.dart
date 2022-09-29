// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_navigator/flutter_navigator.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/screens/screens.dart';

void main() => runZoned<Future<void>>(
      () async {
        runApp(MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: FlutterNavigator().navigatorKey,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: green,
          )),
          home: const Loading(),
        ));
      },
      onError: (dynamic error, StackTrace stackTrace) {
        print("");
      },
    );
