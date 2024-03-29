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
              // const Align(
              //   alignment: AlignmentDirectional.center,
              //   child: Padding(
              //     padding: EdgeInsets.all(8),
              //     child: Text(
              //       'ABOUT',
              //       style: TextStyle(
              //         fontFamily: 'Readex Pro',
              //         fontSize: 64,
              //       ),
              //     ),
              //   ),
              // ),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'From its creation to its purpose, this app is made with love and care for our loved ones. Every aspect reflects our genuine affection, fostering deeper connections and meaningful interactions. Embrace its warmth and intentionality as we celebrate the bonds that truly matter.',
                    style: TextStyle(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
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
                    const Text(
                      'Connecting\n♥️\nOnes',
                      textAlign: TextAlign.center,
                      style: TextStyle(),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    'Sharing is Love, ...from Developer',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
                indent: 24,
                endIndent: 24,
              ),
              const Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'If love was a finding, \nI wouldn\'t have been so lost\n\nIf Soulmates were to be found\nNo Questions wouldve\' been on the trust\n\nIf forever was not an illusion\nWe wouldve\' been still "US"\n\nNo memories renewal, no past reviwed\nI\'d still run to you, I have the guts!',
                    textAlign: TextAlign.center,
                    style: TextStyle(),
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
