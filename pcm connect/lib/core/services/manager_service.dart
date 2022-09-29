import 'package:mobile_flutter/core/api/api.dart';
import 'package:mobile_flutter/core/http/http_client.dart';
import 'package:mobile_flutter/core/models/club_reservation.dart';
import 'package:mobile_flutter/core/models/manager_info.dart';
import 'package:mobile_flutter/core/models/stadium_info.dart';
import 'dart:convert' as convert;

import 'package:mobile_flutter/core/utils/utils.dart';

class ManagerService {
  static Future<List<ClubReservation>?> getClubReservationsList() async {
    try {
      late List<ClubReservation> reservations;
      final response = await HttpClient.get_(ManagerAPI.GET_RESERVATIONS_LIST)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final reservationsList =
            convert.jsonDecode(response.body) as List<dynamic>;
        reservations =
            reservationsList.map(Utils.fromJsonMapToClubReservation).toList();
      }
      return reservations;
    } catch (e, s) {
      return null;
    }
  }

  static Future<ManagerInfo?> getManagerInfo() async {
    try {
      late ManagerInfo managerInfo;
      final response = await HttpClient.get_(ManagerAPI.GET_MANAGER_INFO)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final managerDetails = convert.jsonDecode(response.body) as dynamic;
        managerInfo = Utils.fromJsonMapToManagerInfo(managerDetails);
      }
      return managerInfo;
    } catch (e, s) {
      return null;
    }
  }

  static Future<List<StadiumInfo>?> getClubStadiumsList() async {
    try {
      late List<StadiumInfo> stadiums;
      final response = await HttpClient.get_(ManagerAPI.GET_STADIUMS)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 202) {
        final stadiumsList = convert.jsonDecode(response.body) as List<dynamic>;
        stadiums = stadiumsList.map(Utils.fromJsonMapToStadiumInfo).toList();
      }
      return stadiums;
    } catch (e, s) {
      return null;
    }
  }
}
