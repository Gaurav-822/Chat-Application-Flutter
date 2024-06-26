import 'package:chat_app/Functions/toasts.dart';
import 'package:chat_app/signIn/auth/email_pass_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUpTool() async {
    setState(() {
      isLoading = true;
    });
    try {
      createUser(emailController.text, passwordController.text);
      signUserIn(emailController.text, passwordController.text);
      await Future.delayed(const Duration(seconds: 2));
    } catch (error) {
      showToastMessage('Error signing in: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 8),
                      child: Text(
                        'Sign In',
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
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
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        controller: emailController,
                        obscureText: false,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: TextFormField(
                        controller: repasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Re-Password',
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (passwordController.text ==
                                repasswordController.text) {
                              signUpTool();
                            } else {
                              showToastMessage(
                                  "Password and Repassword are not same");
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 3,
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'OR',
                              style: Theme.of(context).textTheme.bodyLarge,
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
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () => showToastMessage("Coming"),
                                    child: const FaIcon(
                                      FontAwesomeIcons.google,
                                      size: 24,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => showToastMessage("Coming"),
                                    child: const FaIcon(
                                      FontAwesomeIcons.facebook,
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already a User - ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  GoRouter.of(context).go('/login');
                                },
                              style: const TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Center(
                  child: Lottie.asset(
                    "assets/lotties/loading.json",
                    repeat: true,
                    frameRate: const FrameRate(144),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
