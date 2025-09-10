import 'package:flutter/material.dart';

class NavHelper {
  /// Push a new route
  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Push and replace the current route
  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Push a new route and remove all previous routes
  static Future<T?> pushAndRemoveUntil<T extends Object?>(BuildContext context,
      Widget page, bool Function(Route<dynamic>) predicate) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      predicate,
    );
  }

  /// Push a named route
  static Future<T?> pushNamed<T extends Object?>(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  /// Push and replace the current route with a named route
  static Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Push a named route and remove all previous routes
  static Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
      BuildContext context,
      String routeName,
      bool Function(Route<dynamic>) predicate,
      {Object? arguments}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      predicate,
      arguments: arguments,
    );
  }

  /// Pop the current route
  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.of(context).pop(result);
  }

  /// Check if there's a route to pop
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }
}
