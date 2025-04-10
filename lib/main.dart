import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pantry/data/repository/item_repository.dart';
import 'package:pantry/presentation/bloc/anchored/anchored_bloc.dart';
import 'package:pantry/presentation/bloc/anchored/anchored_event.dart';
import 'package:pantry/presentation/bloc/end_module/end_module_bloc.dart';
import 'package:pantry/presentation/bloc/end_module/end_module_event.dart';
import 'package:pantry/presentation/bloc/item/item_bloc.dart';
import 'package:pantry/presentation/bloc/item/item_event.dart';
import 'package:pantry/presentation/bloc/note/note_bloc.dart';
import 'package:pantry/presentation/bloc/note/note_event.dart';
import 'package:pantry/presentation/bloc/template_module/template_module_bloc.dart';
import 'package:pantry/presentation/bloc/template_module/template_module_event.dart';
import 'package:pantry/presentation/bloc/theme/theme_bloc.dart';
import 'core/theme/app_theme.dart';
import 'data/repository/anchored_repository.dart';
import 'data/repository/end_module_repository.dart';
import 'data/repository/notes_repository.dart';
import 'data/repository/template_module_repository.dart';
import 'localization/lang/app_localizations.dart';
import 'presentation/bloc/bottom_nav/bottom_nav_bloc.dart';
import 'presentation/pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationBloc()),

        // ✅ Add ThemeBloc
        BlocProvider(create: (_) => ThemeBloc()),

        // Anchored Module Bloc
        BlocProvider(create: (_) => AnchoredBloc(AnchoredRepository())..add(LoadAnchoredItems())),

        // Item Module Bloc
        BlocProvider(create: (_) => ItemBloc(ItemRepository())..add(LoadFoldersAndItemsEvent())),

        // Notes Module Bloc
        BlocProvider(create: (_) => NotesBloc(NotesRepository())..add(LoadNotes())),

        // Template Module Bloc
        BlocProvider(create: (_) => TemplateModuleBloc(TemplateModuleRepository())..add(LoadTemplateModules())),

        // End Module Bloc
        BlocProvider(create: (_) => EndModuleBloc(EndModuleRepository())..add(LoadEndModules())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pantry App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hi'),
            ],
            locale: const Locale('en'),
            home:  HomePage(),
          );
        },
      ),
    );
  }
}
