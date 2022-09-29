import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/models/models.dart';
import 'package:mobile_flutter/core/services/player_service.dart';
import 'package:mobile_flutter/widgets/blog.dart';

class BlogsList extends StatefulWidget {
  const BlogsList({Key? key}) : super(key: key);

  @override
  State<BlogsList> createState() => _BlogsListState();
}

class _BlogsListState extends State<BlogsList>
    with AutomaticKeepAliveClientMixin {
  bool loaded = false;
  List<BlogInfo>? blogs;
  bool timeOutError = false;

  @override
  void initState() {
    try {
      PlayerService.getBlogsList()
          .then((value) {
            if (value == null) {
              setState(() {
                timeOutError = true;
                loaded = false;
              });
            } else {
              setState(() {
                blogs = value;
                loaded = true;
                timeOutError = false;
              });
            }
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              timeOutError = true;
              loaded = false;
            });
          });
    } catch (e, s) {
      setState(() {
        timeOutError = true;
        loaded = false;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return timeOutError
        ? const Text("Vérifiez votre connection internet !")
        : Container(
            child: loaded
                ? SingleChildScrollView(
                    child: Column(
                      children: [for (var blog in blogs!) Blog(blogInfo: blog)],
                    ),
                  )
                : const SpinKitRing(
                    color: Color.fromARGB(243, 19, 215, 156),
                    size: 25,
                  ),
          );
  }

  @override
  bool get wantKeepAlive => false;
}
