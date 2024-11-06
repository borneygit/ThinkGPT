import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviderBuilder<B extends BlocBase<S>, S> extends StatelessWidget {
  final B Function(BuildContext context) create;
  final Widget Function(BuildContext context, S state) builder;

  const BlocProviderBuilder(
      {required this.create, required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: create,
      child: BlocBuilder<B, S>(
        builder: (context, state) {
          return builder(context, state);
        },
      ),
    );
  }
}
