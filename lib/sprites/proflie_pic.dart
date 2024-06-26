import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatefulWidget {
  final String uuid;
  final bool zoom;
  const ProfilePic({super.key, required this.uuid, required this.zoom});

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
      future: getUserImageUrl(widget.uuid),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
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
          );
          // );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          String? imageUrl = snapshot.data;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
            child: Container(
              width: 120,
              height: 120,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: (widget.zoom)
                  ? GestureDetector(
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
                    )
                  : CachedNetworkImage(
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
          );
          // );
        }
      },
    );
  }
}
