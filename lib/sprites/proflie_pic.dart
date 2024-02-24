import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/profile_pic_funs.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  final String name;
  const ProfilePic({super.key, required this.name});

  @override
  State<StatefulWidget> createState() {
    return _ProfilePic();
  }
}

class _ProfilePic extends State<ProfilePic> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getProfilePicUrl(widget.name),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? imageUrl = snapshot.data;
          return Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
              child: Container(
                width: 120,
                height: 120,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CachedNetworkImage(
                                imageUrl: imageUrl ?? '',
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/dummy_user.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        });
                  },
                  child: CachedNetworkImage(
                    imageUrl: imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/dummy_user.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
