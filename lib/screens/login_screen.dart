// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthy_mates/resources/auth_methods.dart';
import 'package:healthy_mates/screens/signup_screen.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:healthy_mates/utils/global_variables.dart';
import 'package:healthy_mates/utils/utils.dart';
import 'package:healthy_mates/widgets/text_field_input.dart';

import '../responsive/mobile_screen.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);

    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreen(),
              mobileScreenLayout: MobileScreen())));
    } else {
      showSnackBar(res, context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
        padding: MediaQuery.of(context).size.width > webScreenSize
            ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
            : const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            //healthy mates
            const Text(
              'HealthyMates',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),

            //svg image
            const SizedBox(
              height: 50,
            ),
            SvgPicture.asset(
              'assets/login.svg',
              height: 100,
              width: 100,
            ),

            //text field input for email
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress),

            //text field input for pswd
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.text,
              isPass: true,
            ),

            //button login
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: loginUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: primaryColor),
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: whiteColor,
                      ))
                    : const Text(
                        'Log in',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
              ),
            ),

            //transition to siging up
            const SizedBox(
              height: 12,
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 10),
                  ),
                ),
                GestureDetector(
                  onTap: navigateToSignup,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 11),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 25,
            )
          ],
        ),
      )),
    );
  }
}
