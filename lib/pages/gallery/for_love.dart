import 'package:flutter/material.dart';

class GalleryForLoved extends StatefulWidget {
  const GalleryForLoved({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GalleryForLoved();
  }
}

class _GalleryForLoved extends State<GalleryForLoved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.chevron_left,
                      size: 36,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(
                          width: 120,
                          height: 120,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/112966037.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_outlined,
                            // color: Theme.of(context).textTheme.subtitle1.color,
                            size: 24,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.add,
                            // color: Theme.of(context).textTheme.subtitle1.color,
                            size: 36,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Icon(
                            Icons.notifications_active,
                            // color: Theme.of(context).textTheme.subtitle1.color,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Gaurav',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 48,
                        ),
                      ),
                    ),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(),
                    ),
                  ],
                ),
              ],
            ),
            Divider(
              thickness: 1,
              indent: 12,
              endIndent: 12,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  scrollDirection: Axis.vertical,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        'https://picsum.photos/seed/338/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        'https://picsum.photos/seed/230/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Image.network(
                        'https://picsum.photos/seed/389/600',
                        width: 300,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Icon(
                      Icons.add,
                      // color: Theme.of(context).textTheme.subtitle1.color,
                      size: 36,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
