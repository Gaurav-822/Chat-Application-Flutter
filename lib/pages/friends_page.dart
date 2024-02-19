import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

// import 'package:percent_indicator/percent_indicator.dart';

class FriendsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  void scanQRCode() async {
    try {
      String qrCodeResult = await QrCodeDartScan.scanQRCode();
      print('Scanned QR code result: $qrCodeResult');
    } catch (e) {
      print('Error scanning QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Your's special...",
                style: TextStyle(
                  fontFamily: 'DancingScript',
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
          //       Text(
          //         '80',
          //         style: TextStyle(
          //           fontFamily: 'Readex Pro',
          //           fontSize: 24,
          //           fontWeight: FontWeight.w300,
          //           // letterSpacing: 1.5,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Colors.black, // Use your preferred color
                  size: 24,
                ),
                SizedBox(
                  height: 100,
                  child: VerticalDivider(
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Colors.black, // Use your preferred color
                  ),
                ),
                Container(
                  width: 75,
                  height: 75,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    'https://picsum.photos/seed/115/600',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 75,
                  height: 75,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    'https://picsum.photos/seed/906/600',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Friends',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 36,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    // color: FlutterFlowTheme.of(context).secondaryText,
                    size: 50,
                  ),
                  onTap: () {
                    return;
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      // controller: _model.textController,
                      // focusNode: _model.textFieldFocusNode,
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
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      // validator:
                      // _model.textControllerValidator.asValidator(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              height: 350,
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gugu'),
                  _buildRow(context, 'Bacha'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gugu'),
                  _buildRow(context, 'Bacha'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gugu'),
                  _buildRow(context, 'Bacha'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                  _buildRow(context, 'Gaurav'),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(8),
          //   child: LinearPercentIndicator(
          //     percent: 0.8,
          //     lineHeight: 50,
          //     animation: true,
          //     animateFromLastPercent: true,
          //     progressColor: Color(0xFF00FF5E),
          //     backgroundColor: Color(0xFFFF2A2A),
          //     center: Text(
          //       'Sentiment',
          //       textAlign: TextAlign.center,
          //       style: TextStyle(
          //         fontSize: 16,
          //       ),
          //     ),
          //     barRadius: Radius.circular(24),
          //     padding: EdgeInsets.zero,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String text) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                // backgroundColor: Colors.transparent,
                // shadowColor: Colors.blueAccent,
                elevation: 4,
                // title: Text(text),
                content: Padding(
                  padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                'https://picsum.photos/seed/427/600',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Text(
                            'Friends: 69',
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/icon.jpg',
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
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
                    child: Text('Close'),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Readex Pro',
                      fontSize: 16,
                    ),
              ),
            ),
            Icon(
              Icons.send_rounded,
              // color: Theme.of(context).secondaryHeaderColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
