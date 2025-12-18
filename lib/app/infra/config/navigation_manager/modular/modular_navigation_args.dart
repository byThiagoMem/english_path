import 'package:flutter_modular/flutter_modular.dart';

import '../../../infra.dart';

/// [INavigationArguments] implementation using [Modular] package
class ModularNavigationArguments implements INavigationArguments {
  @override
  dynamic get data => Modular.args.data;

  @override
  Map<String, dynamic> get params => Modular.args.params;

  @override
  Map<String, String> get queryParams => Modular.args.queryParams;

  @override
  Map<String, List<String>> get queryParamsAll => Modular.args.queryParamsAll;

  @override
  Uri get uri => Modular.args.uri;
}
