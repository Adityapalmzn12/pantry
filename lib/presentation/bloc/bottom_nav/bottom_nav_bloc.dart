// lib/presentation/blocs/navigation/navigation_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'bottom_nav_event.dart';
import 'bottom_nav_state.dart';


class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationState(currentIndex: 0)) {
    on<NavigationTabChanged>((event, emit) {
      emit(NavigationState(currentIndex: event.index));
    });
  }
}
