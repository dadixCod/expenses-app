import 'package:expense/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './providers/providers.dart';
import './screens/screens.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  Future<bool> checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen') ?? false;
    return seen;
  }

  Future<void> setFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Expenses()),
        ChangeNotifierProvider(create: (context) => DatesFilter()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Manrope',
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: checkFirstSeen(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            } else if (snapshot.hasData && !snapshot.data!) {
              // Show onboarding screen
              return OnBoardingScreen(
                onBoardingCompleted: () async {
                  await setFirstSeen();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushReplacementNamed(Auth.routeName);
                },
              );
            } else {
              return const Auth();
            }
          },
        ),
        routes: {
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          NewExpense.routeName: (ctx) => const NewExpense(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          AuthenticationScreen.routeName: (ctx) => const AuthenticationScreen(),
          Auth.routeName: (ctx) => const Auth(),
        },
      ),
    );
  }
}
