import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TheSpecial extends StatefulWidget {
  final String adminUuid, favUuid;
  const TheSpecial({super.key, required this.adminUuid, required this.favUuid});

  @override
  State<StatefulWidget> createState() {
    return _TheSpecial();
  }
}

class _TheSpecial extends State<TheSpecial> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.favorite_rounded,
            size: 24,
          ),
          const SizedBox(
            height: 100,
            child: VerticalDivider(
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
          ),
          GestureDetector(
            // onTap: () => GoRouter.of(context).go("/galleryForAdmin"),
            child: SizedBox(
              width: 100,
              height: 100,
              child: ProfilePic(uuid: getAdminUuid() ?? "", zoom: false),
            ),
          ),
          GestureDetector(
            // onTap: () => GoRouter.of(context).go("/galleryForLove"),
            child: SizedBox(
                width: 100,
                height: 100,
                child: StreamBuilder<String?>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc("profiles")
                      .collection(getAdminUuid() ?? "")
                      .doc("relations")
                      .snapshots()
                      .map((docSnapshot) {
                    if (docSnapshot.exists) {
                      Map<String, dynamic>? data = docSnapshot.data();
                      if (data != null && data.containsKey('Love')) {
                        return data['Love'] as String?;
                      }
                    }
                    return null;
                  }),
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // If the stream is still loading
                      return const CircularProgressIndicator(); // or any other loading indicator
                    } else if (snapshot.hasError) {
                      // If there's an error in fetching the data
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // If the data has been successfully fetched
                      String? loveString = snapshot.data;
                      if (loveString != null) {
                        // Do something with the loveString
                        return ProfilePic(
                          uuid: loveString,
                          zoom: false,
                        );
                      } else {
                        // If loveString is null
                        return const ProfilePic(
                          uuid: "None",
                          zoom: false,
                        );
                      }
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }
}
