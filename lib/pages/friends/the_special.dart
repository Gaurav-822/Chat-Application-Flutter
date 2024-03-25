import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
              // color: Colors.black, // Use your preferred color
            ),
          ),
          GestureDetector(
            onTap: () => GoRouter.of(context).go("/galleryForAdmin"),
            child: SizedBox(
              width: 100,
              height: 100,
              child: ProfilePic(uuid: getAdminUuid() ?? "", zoom: false),
            ),
          ),

          // FutureBuilder(
          //   future: getAdminUuid(),
          //   builder: (context, snapshot) {
          //     return GestureDetector(
          //       onTap: () => GoRouter.of(context).go("/galleryForAdmin"),
          //       child: SizedBox(
          //         width: 100,
          //         height: 100,
          //         // clipBehavior: Clip.antiAlias,
          //         // decoration: const BoxDecoration(
          //         //   shape: BoxShape.circle,
          //         // ),
          //         child: ProfilePic(uuid: getAdminUuid() ?? "", zoom: false),
          //       ),
          //     );
          //   },
          // ),
          GestureDetector(
            onTap: () => GoRouter.of(context).go("/galleryForLove"),
            child: const SizedBox(
              width: 100,
              height: 100,
              // clipBehavior: Clip.antiAlias,
              // decoration: const BoxDecoration(
              //   shape: BoxShape.circle,
              // ),
              child: ProfilePic(
                uuid: "Padmaja",
                zoom: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
