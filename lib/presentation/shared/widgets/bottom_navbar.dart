// lib/presentation/shared/widgets/bottom_navbar.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/bottom_nav/bottom_nav_event.dart';
import '../../bloc/bottom_nav/bottom_nav_state.dart';


class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentIndex,
          onTap: (index) {
            context.read<NavigationBloc>().add(NavigationTabChanged(index));
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Items',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Templates',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note),
              label: 'Notes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.anchor),
              label: 'Anchored',
            ),
          ],
        );
      },
    );
  }
}
