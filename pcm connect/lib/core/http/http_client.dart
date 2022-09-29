import 'dart:convert' as convert;
import 'package:flutter_navigator/flutter_navigator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:mobile_flutter/core/api/player_api.dart';
import 'package:mobile_flutter/core/api/security_api.dart';
import 'package:mobile_flutter/screens/login.dart';

class HttpClient {
  static const storage = FlutterSecureStorage();

  static Future get_(String url, {Map<String, String>? headers}) async {
    await checkUserAuthentication();
    Map<String, String>? hdrs;
    await checkHeaders(headers).then((value) => hdrs = value);
    final response =
        get(Uri.parse(url), headers: hdrs).timeout(const Duration(seconds: 30));
    return response;
  }

  static Future post_(String url,
      {Map<String, String>? headers, required Object body}) async {
    await checkUserAuthentication();
    Map<String, String>? hdrs;
    await checkHeaders(headers).then((value) => hdrs = value);
    final response = post(Uri.parse(url), headers: hdrs, body: body)
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future put_(String url,
      {Map<String, String>? headers, Object? body}) async {
    await checkUserAuthentication();
    Map<String, String>? hdrs;
    await checkHeaders(headers).then((value) => hdrs = value);
    final response = put(Uri.parse(url), headers: hdrs, body: body)
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static Future delete_(String url,
      {Map<String, String>? headers, Object? body}) async {
    await checkUserAuthentication();
    Map<String, String>? hdrs;
    await checkHeaders(headers).then((value) => hdrs = value);
    final response = delete(Uri.parse(url), headers: hdrs, body: body)
        .timeout(const Duration(seconds: 30));
    return response;
  }

  static checkUserAuthentication() async {
    try {
      String? accessToken = await storage.read(key: "access_token");
      String? refreshToken = await storage.read(key: "refresh_token");
      final defaultHeaders = {"Authorization": "Bearer $accessToken"};
      await get(Uri.parse(PlayerAPI.GET_ALL_CLUBS_LIST),
              headers: defaultHeaders)
          .then((value) async {
        if (value.statusCode != 202) {
          try {
            await post(Uri.parse(SecurityAPI.REFRESH_TOKEN_API),
                    body: {},
                    headers: {"Authorization": "Bearer $refreshToken"})
                .then((value) async {
              if (value.statusCode == 200) {
                final jsonResponse =
                    convert.jsonDecode(value.body) as Map<String, dynamic>;
                storage.deleteAll();
                await storage.write(
                    key: "access_token", value: jsonResponse['access_token']);
                await storage.write(
                    key: "refresh_token", value: jsonResponse['refresh_token']);
                await storage.write(key: "role", value: jsonResponse['role']);
              } else {
                storage.deleteAll();
                final FlutterNavigator flutterNavigator = FlutterNavigator();
                flutterNavigator.push(Login.route());
              }
            }).timeout(const Duration(seconds: 30));
          } catch (e, s) {}
        }
      }).timeout(const Duration(seconds: 30));
    } catch (e, s) {}
  }

  static Future<Map<String, String>> checkHeaders(
      Map<String, String>? headers) async {
    String? accessToken = await storage.read(key: "access_token");
    final defaultHeaders = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken"
    };
    if (headers == null) {
      return defaultHeaders;
    } else {
      headers = {...defaultHeaders, ...headers};
      return headers;
    }
  }
}
