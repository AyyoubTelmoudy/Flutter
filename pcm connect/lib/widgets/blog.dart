// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/colors/colors.dart';
import 'package:mobile_flutter/core/models/blog_info.dart';
import 'package:mobile_flutter/core/models/comment.dart';
import 'package:mobile_flutter/core/services/player_service.dart';

class Blog extends StatefulWidget {
  const Blog({Key? key, required this.blogInfo}) : super(key: key);
  final BlogInfo blogInfo;

  @override
  State<Blog> createState() => _BlogState(blogInfo);
}

class _BlogState extends State<Blog> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  bool showComments = false;
  bool showAddCommendField = false;
  bool commentsLoaded = false;
  final BlogInfo blogInfo;
  String newComment = "";
  List<Comment>? comments;
  String successMessage = "";
  bool timeOutError = false;
  bool getCommentTimeOutError = false;
  bool loading = false;
  _BlogState(this.blogInfo);
  @override
  void initState() {
    try {
      PlayerService.getBlogComments(blogInfo.publicId!)
          .then((value) {
            if (value == null) {
              setState(() {
                commentsLoaded = false;
                getCommentTimeOutError = true;
              });
            } else {
              setState(() {
                comments = value;
                commentsLoaded = true;
                getCommentTimeOutError = false;
              });
            }
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              commentsLoaded = false;
              getCommentTimeOutError = true;
            });
          });
    } catch (e, s) {
      setState(() {
        commentsLoaded = false;
        getCommentTimeOutError = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: green, borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              leading: Text(
                blogInfo.authorEmail!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              title: Text(blogInfo.content!),
              onTap: () {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          getCommentTimeOutError
              ? const Text("Vérifiez votre connection internet !")
              : showComments && commentsLoaded
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          for (var comment in comments!)
                            ListTile(
                              leading: Text(
                                comment.authorEmail!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(comment.comment!),
                              onTap: () {},
                            ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  showComments = !showComments;
                });
              },
              child: Row(
                children: [
                  showComments
                      ? const Icon(Icons.remove)
                      : const Icon(Icons.add),
                  const Text("Commentaires")
                ],
              )),
          showAddCommendField
              ? Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ecrire quelque chose ...',
                              ),
                              onChanged: (val) {
                                setState(() {
                                  newComment = val;
                                });
                              },
                              validator: (val) {
                                return val!.isEmpty
                                    ? 'Ce champ est obligatoire'
                                    : null;
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      successMessage.isNotEmpty
                          ? Text(successMessage)
                          : const SizedBox.shrink(),
                      timeOutError
                          ? const Text("Vérifiez votre connection internet !")
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addComment();
                            }
                          },
                          child: loading
                              ? const SpinKitRing(
                                  color: Colors.white,
                                  size: 25,
                                )
                              : const Text("Publier "))
                    ],
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showAddCommendField = !showAddCommendField;
                          });
                        },
                        child: const Text("Ajouter un commentaire"))
                  ],
                )
        ],
      ),
    );
  }

  _addComment() {
    setState(() {
      loading = true;
      timeOutError = false;
    });
    try {
      PlayerService.addCommentToBlog(blogInfo.publicId!, newComment)
          .then((value) {
            PlayerService.getBlogComments(blogInfo.publicId!).then((value) {
              setState(() {
                comments = value;
              });
            });
          })
          .then((value) {
            setState(() {
              showComments = true;
              loading = false;
              successMessage = "Commentaire a été bien ajouté ";
              timeOutError = false;
              _formKey.currentState!.reset();
            });
          })
          .timeout(const Duration(seconds: 30))
          .onError((error, stackTrace) {
            setState(() {
              successMessage = "";
              timeOutError = true;
              loading = false;
            });
          });
    } catch (e, s) {
      setState(() {
        successMessage = "";
        timeOutError = true;
        loading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => false;
}
