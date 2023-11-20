import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_verification/blocs/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // Initialize Firebase Authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    context.read<AuthBloc>().add(AuthSignOut());
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 244, 54, 190), // Set the button color to red
                  ),
                  child: const Text('Sign Out'),
                ),
                const SizedBox(height: 16),
                Text('Name: ${_auth.currentUser?.displayName ?? 'Alejandro Montero'}'), // Display user's name
                Text('Email: ${_auth.currentUser?.email ?? 'N/A'}'), // Display user's email
              ],
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
