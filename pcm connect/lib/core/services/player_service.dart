import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';
import 'dart:convert' as convert;
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/models/player_info.dart';
import 'package:mobile_flutter/core/utils/utils.dart';

class PlayerService {
  static Future<List<ClubIfo>?> getClubsList() async {
    try {
      late List<ClubIfo> clubs;
      final response = await HttpClient.get_(PlayerAPI.GET_ALL_CLUBS_LIST)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final clubsList = convert.jsonDecode(response.body) as List<dynamic>;
        clubs = clubsList.map(Utils.fromJsonMapToClubInfo).toList();
      }
      return clubs;
    } catch (e, s) {
      return null;
    }
  }

  static Future<List<ReservationInfo>?> getReservationsList() async {
    try {
      late List<ReservationInfo> reservations;
      final response = await HttpClient.get_(PlayerAPI.GET_RESERVATIONS_LIST)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final reservationsList =
            convert.jsonDecode(response.body) as List<dynamic>;
        reservations =
            reservationsList.map(Utils.fromJsonMapToReservationInfo).toList();
      }
      return reservations;
    } catch (e, s) {
      return null;
    }
  }

  static Future<List<BlogInfo>?> getBlogsList() async {
    try {
      late List<BlogInfo> blogs;
      final response = await HttpClient.get_(PlayerAPI.GET_ALL_BLOGS_LIST)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final reservationsList =
            convert.jsonDecode(response.body) as List<dynamic>;
        blogs = reservationsList.map(Utils.fromJsonMapToBlogInfo).toList();
      }
      return blogs;
    } catch (e, s) {
      return null;
    }
  }

  static Future<List<Comment>?> getBlogComments(String blogPublicId) async {
    try {
      late List<Comment> comments;
      final response = await HttpClient.get_(PlayerAPI.GET_BLOG_COMMENTS,
              headers: {"publicId": blogPublicId})
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final commentsList = convert.jsonDecode(response.body) as List<dynamic>;
        comments = commentsList.map(Utils.fromJsonMapToComment).toList();
      }
      return comments;
    } catch (e, s) {
      return null;
    }
  }

  static Future<PlayerInfo?> getPlayerInfo() async {
    try {
      late PlayerInfo playerInfo;
      final response = await HttpClient.get_(PlayerAPI.GET_PLAYER_INFO)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final playerDetails = convert.jsonDecode(response.body) as dynamic;
        playerInfo = Utils.fromJsonMapToPlayerInfo(playerDetails);
      }
      return playerInfo;
    } catch (e, s) {
      return null;
    }
  }

  static Future<void> addCommentToBlog(
      String blogPublicId, String comment) async {
    try {
      final response = await HttpClient.post_(PlayerAPI.ADD_COMMENT,
              body: '{"blogPublicId": "$blogPublicId","comment":"$comment"}')
          .timeout(const Duration(seconds: 30));
      return response;
    } catch (e, s) {
      return;
    }
  }

  static Future<void> createBlog(String blogContent) async {
    try {
      final response = await HttpClient.post_(PlayerAPI.CREATE_BLOG,
              body: '{"content":"$blogContent"}')
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e, s) {
      return;
    }
  }
}
