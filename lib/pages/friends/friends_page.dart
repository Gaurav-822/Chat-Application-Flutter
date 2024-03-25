import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Functions/scanner.dart';
import 'package:chat_app/Functions/user/friends.dart';
import 'package:chat_app/Functions/user/get_info.dart';
import 'package:chat_app/pages/friends/the_special.dart';
import 'package:chat_app/sprites/proflie_pic.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<StatefulWidget> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _searchFocusNode = FocusNode();
  List<List<String>> filteredFriends = [];

  List<List<String>> nestedList = [];

  // late String adminUUID;

  @override
  void initState() {
    super.initState();

    // getAdminUUID();
    getNestedList();
  }

  void getNestedList() async {
    nestedList = await getNestedData();
    setState(() {
      filteredFriends = nestedList;
    });
  }

  void filterFriendsList(String query) {
    setState(() {
      filteredFriends = nestedList
          .where(
              (friend) => friend[0].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // void getAdminUUID() async {
  //   adminUUID = await getAdminLocally();
  // }

  Future<void> _scanQRCode() async {
    String? scanResult = await scanQRCode();
    String? name = await getUserName(scanResult!);

    setState(() {
      filteredFriends.add([name!, scanResult]);
    });

    setState(() async {
      await addElementToNestedList([name!, scanResult]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your's special",
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          TheSpecial(adminUuid: "adminUUID", favUuid: "favUuid"),
          // Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       const Icon(
          //         Icons.favorite_rounded,
          //         size: 24,
          //       ),
          //       const SizedBox(
          //         height: 100,
          //         child: VerticalDivider(
          //           thickness: 1,
          //           indent: 16,
          //           endIndent: 16,
          //           // color: Colors.black, // Use your preferred color
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () => GoRouter.of(context).go("/galleryForAdmin"),
          //         child: SizedBox(
          //           width: 100,
          //           height: 100,
          //           // clipBehavior: Clip.antiAlias,
          //           // decoration: const BoxDecoration(
          //           //   shape: BoxShape.circle,
          //           // ),
          //           child: ProfilePic(uuid: adminUUID, zoom: false),
          //         ),
          //       ),
          //       GestureDetector(
          //         onTap: () => GoRouter.of(context).go("/galleryForLove"),
          //         child: const SizedBox(
          //           width: 100,
          //           height: 100,
          //           // clipBehavior: Clip.antiAlias,
          //           // decoration: const BoxDecoration(
          //           //   shape: BoxShape.circle,
          //           // ),
          //           child: ProfilePic(
          //             uuid: "Padmaja",
          //             zoom: false,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Friends',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 36,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 50,
                  ),
                  onTap: () {
                    _scanQRCode();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      focusNode: _searchFocusNode,
                      controller: searchController,
                      onChanged: (value) {
                        filterFriendsList(value);
                      },
                      autofocus: false,
                      obscureText: false,
                      decoration: const InputDecoration(
                        hintText: 'Search. . .',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(width: 0.25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                          borderSide: BorderSide(width: 0.25),
                        ),
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 350,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: filteredFriends.length, // Use filteredFriends.length
                itemBuilder: (context, index) {
                  return _buildRow(
                      context,
                      filteredFriends[index][0],
                      filteredFriends[index][1],
                      filteredFriends.length); // Use filteredFriends[index]
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
      BuildContext context, String name, String uuid, int totalFriends) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                elevation: 4,
                content: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 36,
                              ),
                            ),
                            Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: FutureBuilder(
                                    // correct this
                                    future: getUserImageUrl(uuid),
                                    builder: (context, snapshot) {
                                      String imageURL = snapshot.data ?? '';
                                      return CachedNetworkImage(
                                        imageUrl: imageURL,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          "assets/dummy_user.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    })),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Text(
                            'Friends: $totalFriends',
                          ),
                        ),
                        const SizedBox(height: 24),
                        QrImageView(
                          data: "Titly/$uuid",
                          version: QrVersions.auto,
                          size: 175.0,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                name,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                    ),
              ),
            ),
            FutureBuilder(
                future: getUserName(uuid),
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      // saveChatName(name);
                      GoRouter.of(context).go('/chats/${snapshot.data}/$uuid');
                      updateFriendUpdated(uuid);
                    },
                    child: const Icon(
                      Icons.send_rounded,
                      size: 24,
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
