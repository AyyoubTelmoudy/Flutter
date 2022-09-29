// ignore_for_file: non_constant_identifier_names

import 'package:mobile_flutter/core/constant/constnats.dart';

class ManagerAPI {
  static final String REGISTER = BASE_URL + "/api/managers/register";
  static final String RESERVE_GAME = BASE_URL + "/api/managers/reserve-game";
  static final String ADD_STADIUM = BASE_URL + "/api/managers/add-stadium";
  static final String CREATE_BLOG = BASE_URL + "/api/managers/create-blog";
  static final String ADD_COMMENT = BASE_URL + "/api/managers/add-comment";
  static final String GET_RESERVATIONS_LIST =
      BASE_URL + "/api/managers/get-reservations";
  static final String GET_MANAGER_INFO =
      BASE_URL + "/api/managers/get-manager-info";
  static final String GET_STADIUMS = BASE_URL + "/api/managers/get-stadiums";
}
