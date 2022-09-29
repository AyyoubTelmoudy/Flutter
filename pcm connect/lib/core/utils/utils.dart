import 'package:flutter/material.dart';
import 'package:flutter_navigator/flutter_navigator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_flutter/core/constant/constnats.dart';
import 'package:mobile_flutter/core/models/club_reservation.dart';
import 'package:mobile_flutter/core/models/manager_info.dart';
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/models/player_info.dart';
import 'package:mobile_flutter/core/models/stadium_info.dart';
import 'package:mobile_flutter/screens/manager_reservation.dart';
import 'package:mobile_flutter/screens/screens.dart';

class Utils {
  static void redirectUser(BuildContext context) async {
    const storage = FlutterSecureStorage();
    await storage.read(key: ROLE).then((role) {
      if (role == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        if (role == PLAYER_ROLE) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerReservation()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ManagerReservation()),
          );
        }
      }
    });
  }

  static ClubIfo fromJsonMapToClubInfo(e) {
    ClubIfo club = ClubIfo();
    club.name = e['name'];
    club.publicId = e['publicId'];
    club.country = e['country'];
    club.neighborhood = e['neighborhood'];
    club.zipCode = e['zipCode'];
    club.phone = e['phone'];
    club.email = e['email'];
    club.monday = fromJsonMapToDay(e['monday']);
    club.tuesday = fromJsonMapToDay(e['tuesday']);
    club.wednesday = fromJsonMapToDay(e['wednesday']);
    club.thursday = fromJsonMapToDay(e['thursday']);
    club.friday = fromJsonMapToDay(e['friday']);
    club.saturday = fromJsonMapToDay(e['saturday']);
    club.sunday = fromJsonMapToDay(e['sunday']);
    return club;
  }

  static Day fromJsonMapToDay(e) {
    Day day = Day();
    day.closingHour = e['closingHour'];
    day.closingMin = e['closingMin'];
    day.openingHour = e['openingHour'];
    day.openingMin = e['openingMin'];
    return day;
  }

  static Game fromJsonMapToGame(e) {
    Game game = Game();
    game.publicId = e['publicId'];
    game.date = e['date'];
    game.startHour = e['startHour'];
    game.startMin = e['startMin'];
    game.endHour = e['endHour'];
    game.endMin = e['endMin'];
    return game;
  }

  static ReservationInfo fromJsonMapToReservationInfo(e) {
    ReservationInfo reservation = ReservationInfo();
    reservation.publicId = e['publicId'];
    reservation.num = e['num'];
    reservation.amount = e['amount'];
    reservation.clubName = e['clubName'];
    reservation.date = e['date'];
    reservation.validated = e['validated'];
    reservation.game = fromJsonMapToGame(e['game']);
    return reservation;
  }

  static ClubReservation fromJsonMapToClubReservation(e) {
    ClubReservation clubReservation = ClubReservation();
    clubReservation.publicId = e['publicId'];
    clubReservation.num = e['num'];
    clubReservation.amount = e['amount'];
    clubReservation.playerEmail = e['playerEmail'];
    clubReservation.date = e['date'];
    clubReservation.validated = e['validated'];
    clubReservation.game = fromJsonMapToGame(e['game']);
    return clubReservation;
  }

  static BlogInfo fromJsonMapToBlogInfo(e) {
    BlogInfo blogInfo = BlogInfo();
    blogInfo.publicId = e['publicId'];
    blogInfo.content = e['content'];
    blogInfo.authorEmail = e['authorEmail'];
    List<Comment> comments = <Comment>[];
    for (var item in e['comments']) {
      Comment comment = Comment();
      comment.publicId = item['publicId'];
      comment.comment = item['comment'];
      comment.authorEmail = item['authorEmail'];
      comments.add(comment);
    }
    blogInfo.comments = comments;
    return blogInfo;
  }

  static Comment fromJsonMapToComment(e) {
    Comment comment = Comment();
    comment.publicId = e['publicId'];
    comment.comment = e['comment'];
    comment.authorEmail = e['authorEmail'];
    return comment;
  }

  static PlayerInfo fromJsonMapToPlayerInfo(e) {
    PlayerInfo playerInfo = PlayerInfo();

    playerInfo.firstName = e['firstName'];
    playerInfo.lastName = e['lastName'];
    playerInfo.level = e['level'];
    playerInfo.email = e['email'];
    return playerInfo;
  }

  static ManagerInfo fromJsonMapToManagerInfo(e) {
    ManagerInfo managerInfo = ManagerInfo();
    managerInfo.firstName = e['firstName'];
    managerInfo.lastName = e['lastName'];
    managerInfo.clubName = e['clubName'];
    managerInfo.email = e['email'];
    return managerInfo;
  }

  static StadiumInfo fromJsonMapToStadiumInfo(e) {
    StadiumInfo stadiumInfo = StadiumInfo();
    stadiumInfo.num = e['num'];
    stadiumInfo.publicId = e['publicId'];
    stadiumInfo.size = e['size'];
    return stadiumInfo;
  }

  static String toPlayerGameReservation(DateTime date, String size,
      String clubName, bool check, TimeOfDay startTime, TimeOfDay endTime) {
    String month =
        date.month <= 9 ? "0" + date.month.toString() : date.month.toString();
    String day =
        date.day <= 9 ? "0" + date.day.toString() : date.day.toString();
    var json =
        '{"date":"${date.year}-$month-$day","clubName":"$clubName","size":"$size","startHour":${startTime.hour},"startMin":${startTime.minute},"endHour":${endTime.hour},"endMin":${startTime.minute},"check":$check}';
    return json;
  }

  static String toPlayerRegisterRequestString(
      String firstName,
      String lastName,
      String email,
      String password,
      String level,
      String city,
      String country,
      String neighborhood) {
    return '{"lastName": "$lastName","firstName": "$firstName","email": "$email","password": "$password","level": "$level","city": "$city","country": "$country","neighborhood": "$neighborhood"}';
    ;
  }

  static String toManagerRegisterRequestString(
      String firstName,
      String lastName,
      String email,
      String password,
      String clubName,
      String webSite,
      String city,
      String country,
      String neighborhood,
      String zipCode,
      String clubPhone,
      String clubEmail,
      TimeOfDay openingTime,
      TimeOfDay closingTime) {
    return '{"lastName": "$lastName","firstName": "$firstName","password": "$password","email": "$email","clubName":"$clubName","webSite":"$webSite","city": "$city","country": "$country","neighborhood": "$neighborhood","zipCode":"$zipCode","clubPhone":"$clubPhone","clubEmail":"$clubEmail","openingHour":${openingTime.hour},"openinMin":${openingTime.minute},"closingHour":${closingTime.hour},"closingMin":${closingTime.minute}}';
  }

  static String toManagerGameReservation(DateTime date, String size,
      String playerEmail, bool check, TimeOfDay startTime, TimeOfDay endTime) {
    String month =
        date.month <= 9 ? "0" + date.month.toString() : date.month.toString();
    String day =
        date.day <= 9 ? "0" + date.day.toString() : date.day.toString();
    var json =
        '{"date":"${date.year}-$month-$day","playerEmail":"$playerEmail","size":"$size","startHour":${startTime.hour},"startMin":${startTime.minute},"endHour":${endTime.hour},"endMin":${startTime.minute},"check":$check}';
    return json;
  }

  static void logOut() {
    const storage = FlutterSecureStorage();
    storage.deleteAll();
    final FlutterNavigator flutterNavigator = FlutterNavigator();
    flutterNavigator.push(Home.route());
  }
}
