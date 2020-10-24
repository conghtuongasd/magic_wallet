import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

typedef HookWidgetBuilder<Handler> = Widget Function(
    BuildContext context, Handler store);

abstract class ContextProviderWidget<T> extends HookWidget {
  final Widget child;
  final HookWidgetBuilder<T> builder;

  ContextProviderWidget({this.child, this.builder});

  Widget provide(BuildContext context, T handler) {
    GetIt.instance.registerSingleton<T>(handler);
    return builder != null ? builder(context, handler) : child;
  }
}
