import 'package:flutter/material.dart';

import '../models/navigation_model.dart';

@immutable
class NavigationState {
  final List<NavigationModel> routes;

  const NavigationState({this.routes});

  factory NavigationState.initial() {
    return const NavigationState(routes: []);
  }

  NavigationState copyWith({List<NavigationModel> routes}) {
    return NavigationState(
      routes: routes ?? this.routes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavigationState && runtimeType == other.runtimeType && routes == other.routes;

  @override
  int get hashCode => super.hashCode;
}
