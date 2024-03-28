// for now i will make the chat row as a stateless widget!
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:flutter/material.dart';

class ChatRow extends StatelessWidget {
  final String name;
  final String uuid;
  final VoidCallback onTap;
  const ChatRow({
    super.key,
    required this.name,
    required this.uuid,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: FutureBuilder<String?>(
                  future: getUserImageUrl(uuid),
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Data has been successfully retrieved
                      String? profilePicPath = snapshot.data;
                      return CachedNetworkImage(
                        imageUrl: profilePicPath ??
                            '', // Use an empty string for local assets
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(), // Placeholder widget while loading
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/dummy_user.jpg',
                          fit: BoxFit.cover,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
