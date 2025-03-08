import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/features/consumer/presentation/bloc/consumer_bloc.dart';
import 'package:gas/features/consumer/presentation/widgets/consumer_main_widgets.dart';

class ConsumerMainPage extends StatefulWidget {
  const ConsumerMainPage({super.key});

  @override
  State<ConsumerMainPage> createState() => _ConsumerMainPageState();
}

class _ConsumerMainPageState extends State<ConsumerMainPage> {
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConsumerBloc, ConsumerState>(
      builder: (context, state) {
        if (state is ConsumerGettingAllConsumers) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (context, index) {
                return const ConsumerGettingAllConsumersShimmer();
              });
        }
        if (state is ConsumerAllConsumersFetched) {
          if (state.consumers.isEmpty) {
            return const Center(
              child: Text("Empty List"),
            );
          }
          final consumers = state.consumers
              .where((consumer) => !consumer.deactivate)
              .toList()
              .reversed
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: consumers.length,
                  itemBuilder: (context, index) {
                    final consumer = consumers[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConsumerMainPageTile(
                          consumer: consumer,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.consumerDetail,
                                arguments: {"consumer": consumer});
                          },
                        ),
                        if (index != consumers.length - 1) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25.w),
                            child: Divider(
                                height: 1,
                                color: Colors.black12.withOpacity(.1)),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return const ConsumerGettingAllConsumersShimmer();
            });
      },
    );
  }
}
