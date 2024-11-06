import 'package:flutter_bloc/flutter_bloc.dart';

class SideBarCubit extends Cubit<bool> {
  SideBarCubit() : super(true);

  void toggleSideBar() => emit(!state);

  bool get isSidebarExpanded => state;
}
