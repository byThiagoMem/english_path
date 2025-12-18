import 'package:flutter/widgets.dart';

///
/// Interface for navigation
///
abstract class INavigation {
  /// Returns the [NavigationArguments] instance
  INavigationArguments get args;

  /// Returns the current route path
  String get currentPath;

  ///
  /// Push a named route to the stack
  ///
  Future<T?> pushNamed<T extends Object?>(
    Object path, {
    Object? arguments,
    bool? forRoot,
  });

  ///
  /// Push and replace a named route
  ///
  Future<Object?> pushReplacementNamed(
    Object path, {
    Object? arguments,
    bool? forRoot,
  });

  ///
  /// Push a named route and remove routes according to [predicate]
  ///
  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    Object path,
    bool Function(Route) predicate, {
    Object? arguments,
    bool? forRoot,
  });

  ///
  /// Removes all previous routes and navigate to a route.
  ///
  void navigate(Object path, {dynamic arguments});

  ///
  /// Pop the current route out of the stack
  ///
  void pop<T extends Object>({T? response});

  ///
  /// Calls pop repeatedly on the navigator until the predicate returns true.
  ///
  void popUntil(bool Function(Route<dynamic>) predicate);

  ///
  /// Return true if route can pop
  ///
  bool canPop();

  /// Pop the current route off the navigator and navigate to a route
  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
    bool forRoot = false,
  });

  ///
  /// Consults the current route's [Route.popDisposition] method,
  /// and acts accordingly,
  /// potentially popping the route as a result;
  /// returns whether the pop request should be considered handled.
  ///
  Future<bool> maybePop<T extends Object?>([T? result]);

  /// Register a closure to be called when the object notifies its listeners.
  void addListener(VoidCallback listener);

  /// Remove a previously registered closure from the list of closures that the
  /// object notifies.
  void removeListener(VoidCallback listener);

  ///
  /// Current navigation history
  ///
  List<String> get history;
}

/// Object that clusters all arguments and parameters retrieved or produced
/// during a route search.
abstract class INavigationArguments {
  /// It retrieves parameters after consulting a dynamic route. If it is not
  /// a dynamic route the object will be an empty Map.
  /// ex: /product/:id  ->  /product/1
  /// NavigationArguments.params['id']; -> '1'
  Map<String, dynamic> get params;

  /// Uri of current route.
  Uri get uri;

  /// Retrieved from a direct input of arguments from the navigation
  /// system itself.
  /// ex: Navigation.to.navigate('/product', arguments: Products());
  /// NavigationArguments.data;  -> Product();
  dynamic get data;

  /// The URI query split into a map according to the rules specified for
  ///  FORM post in the HTML 4.01 specification section 17.13.4.
  /// Each key and value in the resulting map has been decoded. If there is
  /// no query the empty map is returned.
  /// Keys in the query string that have no value are mapped to the empty
  /// string. If a key occurs more than once in the query string, it is mapped
  /// to an arbitrary choice of possible value. The [queryParametersAll]
  /// getter can provide a map that maps keys to all of their values.
  /// The map and the lists it contains are unmodifiable.
  Map<String, String> get queryParams => uri.queryParameters;

  /// Returns the URI query split into a map according to the rules specified
  /// for FORM post in the HTML 4.01 specification section 17.13.4.
  /// Each key and value in the resulting map has been decoded. If there is no
  /// query the map is empty.
  /// Keys are mapped to lists of their values. If a key occurs only once,
  /// its value is a singleton list. If a key occurs with no value, the empty
  /// string is used as the value for that occurrence.
  /// The map and the lists it contains are unmodifiable.
  Map<String, List<String>> get queryParamsAll => uri.queryParametersAll;
}
