import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_verification/blocs/auth/auth_bloc.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthSignOut());
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 244, 54, 190), // Set the button color to red
              ),
              child: const Text('Sign Out'),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
