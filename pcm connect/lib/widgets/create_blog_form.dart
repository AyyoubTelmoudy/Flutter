import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_flutter/core/services/player_service.dart';

class CreateBlogForm extends StatefulWidget {
  const CreateBlogForm({Key? key}) : super(key: key);

  @override
  State<CreateBlogForm> createState() => _CreateBlogFormState();
}

class _CreateBlogFormState extends State<CreateBlogForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  String blogContent = "";
  String backendMessage = "";
  bool timeOutError = false;
  bool loading = false;
  String successMessage = "";
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
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
                      blogContent = val;
                    });
                  },
                  validator: (val) {
                    return val!.isEmpty ? 'Ce champ est obligatoire' : null;
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
                  _addBlog();
                }
              },
              child: loading
                  ? const SpinKitRing(
                      color: Colors.white,
                      size: 25,
                    )
                  : const Text("Publier"))
        ],
      ),
    );
  }

  _addBlog() {
    setState(() {
      successMessage = "";
      loading = true;
      timeOutError = false;
    });
    try {
      PlayerService.createBlog(blogContent)
          .then((value) {
            setState(() {
              loading = false;
              successMessage = "Blog a été bien publié";
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
