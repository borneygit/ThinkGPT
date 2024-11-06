import 'package:flutter/cupertino.dart';

abstract class AppStartAction<T> {
  const AppStartAction();

  Future<void> onInject();

  void onLoaded(BuildContext context, T data);

  void onSuccess(BuildContext context);

  void onError(BuildContext context, String message);
}
