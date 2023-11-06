import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qrcode_verification/blocs/auth/auth_bloc.dart';
import 'package:qrcode_verification/firebase_options.dart';
import 'package:qrcode_verification/views/home_view.dart';
import 'package:qrcode_verification/views/signin_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: const AppRouter(),
      ),
    );
  }
}

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthUnauthenticated) {
          return SignInView();
        } else if (state is AuthAuthenticated) {
          // You can navigate to the main app screen or other authenticated screens here.
          return const HomeView();
        } else {
          return SignInView(); // Or any other initial screen.
        }
      },
    );
  }
}




