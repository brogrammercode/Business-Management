import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef TripleBlocWidgetBuilder<S1, S2, S3> = Widget Function(
    BuildContext context, S1 state1, S2 state2, S3 state3);

class TripleBlocBuilder<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>,
    S2, B3 extends BlocBase<S3>, S3> extends StatelessWidget {
  final TripleBlocWidgetBuilder<S1, S2, S3> builder;

  const TripleBlocBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      builder: (context, state1) {
        return BlocBuilder<B2, S2>(
          builder: (context, state2) {
            return BlocBuilder<B3, S3>(
              builder: (context, state3) {
                return builder(context, state1, state2, state3);
              },
            );
          },
        );
      },
    );
  }
}

typedef DoubleBlocWidgetBuilder<S1, S2> = Widget Function(
    BuildContext context, S1 state1, S2 state2);

class DoubleBlocBuilder<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>,
    S2> extends StatelessWidget {
  final DoubleBlocWidgetBuilder<S1, S2> builder;

  const DoubleBlocBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      builder: (context, state1) {
        return BlocBuilder<B2, S2>(
          builder: (context, state2) {
            return builder(context, state1, state2);
          },
        );
      },
    );
  }
}

class DynamicMultiBlocBuilder extends StatelessWidget {
  final List<BlocBase> blocs;
  final Widget Function(BuildContext context, List<dynamic> states) builder;

  const DynamicMultiBlocBuilder(
      {super.key, required this.blocs, required this.builder});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      stream: _combineStreams(blocs),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return builder(context, snapshot.data!);
        }
        return const CircularProgressIndicator(); // Default loading state
      },
    );
  }

  /// Combines multiple Bloc streams into a single Stream.
  Stream<List<dynamic>> _combineStreams(List<BlocBase> blocs) {
    return Stream.periodic(const Duration(milliseconds: 50)).asyncMap((_) {
      return blocs.map((bloc) => bloc.stream.last).toList();
    });
  }
}
