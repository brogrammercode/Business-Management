import 'package:gas/features/auth/data/data_sources/auth_remote_ds.dart';
import 'package:gas/features/auth/domain/repo/auth_repo.dart';
import 'package:gas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:gas/features/consumer/data/data_source/consumer_data_source.dart';
import 'package:gas/features/consumer/data/repo_impl/consumer_repo_impl.dart';
import 'package:gas/features/consumer/domain/repositories/consumer_repo.dart';
import 'package:gas/features/consumer/domain/usecases/add_consumer.dart';
import 'package:gas/features/consumer/domain/usecases/delete_consumer.dart';
import 'package:gas/features/consumer/domain/usecases/get_all_consumers.dart';
import 'package:gas/features/consumer/domain/usecases/update_consumer.dart';
import 'package:gas/features/consumer/presentation/bloc/consumer_bloc.dart';
import 'package:gas/features/organisation/data/data_source/org_remote_ds.dart';
import 'package:gas/features/organisation/domain/repositories/org_repo.dart';
import 'package:gas/features/organisation/presentation/cubit/org_cubit.dart';
import 'package:get_it/get_it.dart';

class Injections {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {

    // auth
    _getIt.registerFactory<AuthRepo>(() => AuthRemoteDs());
    _getIt.registerFactory<AuthCubit>(() => AuthCubit(repo: _getIt()));

    // org
    _getIt.registerFactory<OrgRepo>(() => OrgRemoteDs());
    _getIt.registerFactory<OrgCubit>(() => OrgCubit(repo: _getIt()));

    // consumers
    _getIt.registerFactory<ConsumerDataSource>(() => ConsumerDataSourceImpl());
    _getIt.registerFactory<ConsumerRepo>(
        () => ConsumerRepoImpl(consumerDataSource: _getIt()));
    _getIt.registerFactory<GetAllConsumers>(
        () => GetAllConsumers(repo: _getIt()));
    _getIt.registerFactory<AddConsumer>(() => AddConsumer(repo: _getIt()));
    _getIt
        .registerFactory<UpdateConsumer>(() => UpdateConsumer(repo: _getIt()));
    _getIt
        .registerFactory<DeleteConsumer>(() => DeleteConsumer(repo: _getIt()));
    _getIt.registerFactory<ConsumerBloc>(() => ConsumerBloc(
          getAllConsumers: _getIt(),
          addConsumer: _getIt(),
          updateConsumer: _getIt(),
          deleteConsumer: _getIt(),
        ));
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
