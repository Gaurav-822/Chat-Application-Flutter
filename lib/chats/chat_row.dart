// for now i will make the chat row as a stateless widget!
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRow extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  const ChatRow({
    super.key,
    required this.name,
    required this.onTap,
  });

  Future<String?> getProfilePicUrl(String name) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc('profile')
          .collection('admin')
          .where('name', isEqualTo: name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['url'] as String?;
      } else {
        print('No profile pic found for $name');
        return null;
      }
    } catch (error) {
      print('Error retrieving profile pic: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                  width: 50,
                  height: 50,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: FutureBuilder<String?>(
                    future: getProfilePicUrl(name),
                    builder: (BuildContext context,
                        AsyncSnapshot<String?> snapshot) {
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
                              CircularProgressIndicator(), // Placeholder widget while loading
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/dummy_user.jpg',
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
