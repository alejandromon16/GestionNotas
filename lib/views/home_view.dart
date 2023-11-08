import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode_verification/blocs/auth/auth_bloc.dart';
import 'package:qrcode_verification/views/create_semestre_view.dart';
import 'package:qrcode_verification/views/profile_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1; 

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de Notas'),
        backgroundColor:  const Color.fromARGB(255, 255, 41, 155),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCreateSemestresView(),
          _buildHomeView(),
          _buildProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add), // Icon for Create Semesters
            label: 'Create Semestres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Icon for Home
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for Profile
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildCreateSemestresView() {
    return const CreateSemestresView();
  }

  Widget _buildHomeView() {
    return const Center(
      child: Text('Lista Materias'),
    );
  }

  Widget _buildProfileView() {
    return const ProfileView();
  }
}
