import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "About",
          style: TextStyle(
            fontFamily: "title_font",
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: 0.2,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/icon.jpg',
                              width: 250,
                              height: 200,
                              fit: BoxFit.none,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/about_love.png',
                            width: 250,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    '. . . By Someone . . .',
                    style: TextStyle(
                      fontFamily: "teko",
                      fontSize: 36,
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 48,
                endIndent: 48,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(36, 8, 8, 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'If love was a finding, \nI wouldn\'t have been so lost\n\nIf Soulmates were to be found\nNo Questions wouldve\' been on the trust\n\nIf forever was not an illusion\nWe wouldve\' been still "US"\n\nNo memories renewal, no past reviwed\nI\'d still run to you, I have the guts!',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'LovedByTheKing',
                              fontSize: 24,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 48,
                endIndent: 48,
              ),
              const Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36, 8, 8, 8),
                  child: Text(
                    'Surprise surprise lol,\nso just like this app is made.\nit\'s made to do the same :),\nHope u all get the reason\nfor being our user',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'LovedByTheKing',
                      fontSize: 24,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 48,
                endIndent: 48,
              ),
              const Align(
                alignment: AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36, 8, 8, 8),
                  child: Text(
                    'Well wishes <3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'LovedByTheKing',
                      fontSize: 36,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
