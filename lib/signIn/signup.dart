import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellowAccent.withOpacity(0.15),

      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.red, Colors.yellowAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Sign In',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            // color: Colors.white, // Text color can be adjusted
                            fontWeight: FontWeight
                                .bold, // Example: Applying bold font weight
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/neon_butterfly_cocoon.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: TextFormField(
                    // controller: _model.textController1,
                    // focusNode: _model.textFieldFocusNode1,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Username:',
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    // validator: _model.textController1Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: TextFormField(
                    // controller: _model.textController2,
                    // focusNode: _model.textFieldFocusNode2,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Email:',
                      labelStyle: Theme.of(context).textTheme.subtitle1,
                      hintStyle: Theme.of(context).textTheme.subtitle1,
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.bodyText1,
                    // validator: _model.textController2Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(4),
                  child: TextFormField(
                    // controller: _model.textController3,
                    // focusNode: _model.textFieldFocusNode3,
                    autofocus: false,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Password:',
                      labelStyle: Theme.of(context).textTheme.titleMedium,
                      hintStyle: Theme.of(context).textTheme.titleMedium,
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.bodyLarge,
                    // validator: _model.textController3Validator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'OR',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                        child: VerticalDivider(
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.android,
                                size: 24,
                              ),
                              Icon(
                                Icons.facebook,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Already a User - ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Readex Pro',
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text: 'Log In',
                          style: TextStyle(),
                        )
                      ],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
