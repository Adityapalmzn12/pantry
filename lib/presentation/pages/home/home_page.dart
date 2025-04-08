import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pantry/presentation/bloc/bottom_nav/bottom_nav_state.dart';
import '../../bloc/bottom_nav/bottom_nav_bloc.dart';
import '../../bloc/bottom_nav/bottom_nav_event.dart';
import '../../bloc/language/language_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../bloc/language/language_event.dart';
import '../../bloc/language/language_state.dart';
import '../anchored/anchored_page.dart';
import '../end_module/end_module_page.dart';
import '../item/item_page.dart';
import '../notes/notes_page.dart';
import '../template_module/template_module_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Widget> pages = const [
    ItemPage(),
    TemplateModulePage(),
    EndModulePage(),
    AnchoredPage(),
    NotesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        return Scaffold(
          body: pages[state.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state.currentIndex,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).iconTheme.color?.withOpacity(0.6),
            onTap: (index) {
              context.read<NavigationBloc>().add(NavigationTabChanged(index));
            },
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.home, size: 18),
                ),
                label: AppStrings.navAnchored,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.inventory, size: 18),
                ),
                label: AppStrings.navItems,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.note, size: 18),
                ),
                label: AppStrings.navNotes,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.list, size: 18),
                ),
                label: AppStrings.navTemplate,
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.settings, size: 18),
                ),
                label: AppStrings.navEndModule,
              ),
            ],
            selectedLabelStyle: const TextStyle(fontSize: 10),
            unselectedLabelStyle: const TextStyle(fontSize: 10),
          ),
        );
      },
    );
  }
}
