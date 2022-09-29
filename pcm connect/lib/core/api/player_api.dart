// ignore_for_file: non_constant_identifier_names
import 'package:mobile_flutter/core/constant/constnats.dart';

class PlayerAPI {
  static final GET_ALL_CLUBS_LIST = BASE_URL + "/api/players/clubs-list";
  static final String GET_ALL_BLOGS_LIST = BASE_URL + "/api/shared/blogs";
  static final String RESERVE_GAME = BASE_URL + "/api/players/reserve-game";
  static final String GET_RESERVATIONS_LIST =
      BASE_URL + "/api/players/get-reservations";
  static final String GET_BLOG_COMMENTS =
      BASE_URL + "/api/shared/blog-comments";
  static final String ADD_COMMENT = BASE_URL + "/api/players/add-comment";
  static final String CREATE_BLOG = BASE_URL + "/api/players/create-blog";
  static final String REGISTER = BASE_URL + "/api/players/register";
  static final String GET_PLAYER_INFO =
      BASE_URL + "/api/managers/get-player-info";
}
