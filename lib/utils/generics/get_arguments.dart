import 'package:flutter/material.dart' show BuildContext, ModalRoute;

extension GetArgument on BuildContext {
  T? getArgument<T>() {
    final modalRoute = ModalRoute.of(this);
    // if arguments are found in current modal route
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      // and if this argument is of requested type
      if (args != null && args is T) {
        // return the arguments
        return args as T;
      }
    }
    return null;
  }
}
