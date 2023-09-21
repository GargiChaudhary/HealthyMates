import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthy_mates/providers/user_provider.dart';
import 'package:healthy_mates/responsive/responsive_layout.dart';
import 'package:healthy_mates/responsive/web_screen.dart';
import 'package:healthy_mates/screens/login_screen.dart';
import 'package:healthy_mates/utils/colors.dart';
import 'package:provider/provider.dart';
import 'responsive/mobile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyBeWdveYJ-GavERNCm4grXbBXFHV4qJANc',
            appId: '1:552426250912:web:88fcbcbe8deb34fcd3dfc5',
            messagingSenderId: '552426250912',
            projectId: 'mates-c2d31',
            storageBucket: 'mates-c2d31.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Healthy Mates',

        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),

        // home: const LoginScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    webScreenLayout: WebScreen(),
                    mobileScreenLayout: MobileScreen());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
