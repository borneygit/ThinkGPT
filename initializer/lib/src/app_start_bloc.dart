import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'app_start_action.dart';
import 'app_start_repository.dart';

part 'app_start_bloc.freezed.dart';

class AppStartBloc<T> extends Cubit<AppStatus> {
  final AppStartRepository<T> repository;
  final AppStartAction<T> action;

  AppStartBloc({required this.repository, required this.action})
      : super(const AppStatus.starting());

  Future<void> init() async {
    emit(const AppStatus.starting());
    final start = DateTime.now().millisecondsSinceEpoch;
    try {
      await action.onInject();
      final data = await repository.init();
      emit(AppStatus.done(data));
      final end = DateTime.now().millisecondsSinceEpoch;
      emit(AppStatus.success(end - start));
    } catch (e) {
      emit(AppStatus.failed(e.toString()));
    }
  }
}

@freezed
class AppStatus<T> with _$AppStatus {
  const factory AppStatus.starting() = _Starting<T>;

  const factory AppStatus.success(int dur) = _Success<T>;

  factory AppStatus.failed(String e) = _Failed<T>;

  const factory AppStatus.done(T data) = _Done<T>;
}
