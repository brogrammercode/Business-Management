import 'package:gas/features/auth/data/data_sources/auth_remote_ds.dart';
import 'package:gas/features/auth/domain/repo/auth_repo.dart';
import 'package:gas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:gas/features/business/data/data_source/business_remote_ds.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/delivery/data/data_source/delivery_remote_ds.dart';
import 'package:gas/features/delivery/domain/repo/delivery_repo.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:gas/features/employee/data/data_source/employee_remote_ds.dart';
import 'package:gas/features/employee/domain/repo/employee_remote_repo.dart';
import 'package:gas/features/employee/presentation/cubit/employee_cubit.dart';
import 'package:gas/features/home/data/data_source/home_remote_ds.dart';
import 'package:gas/features/home/domain/repo/home_repo.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:get_it/get_it.dart';

class Injections {
  static final GetIt _getIt = GetIt.instance;

  static Future<void> init() async {

    // auth
    _getIt.registerFactory<AuthRepo>(() => AuthRemoteDs());
    _getIt.registerFactory<AuthCubit>(() => AuthCubit(repo: _getIt()));

    // home
    _getIt.registerFactory<HomeRemoteRepo>(() => HomeRemoteDs());
    _getIt
        .registerFactory<HomeCubit>(() => HomeCubit(homeRemoteRepo: _getIt()));

    // business
    _getIt.registerFactory<BusinessRepo>(() => BusinessRemoteDs());
    _getIt.registerFactory<BusinessCubit>(() => BusinessCubit(repo: _getIt()));

    // employee
    _getIt.registerFactory<EmployeeRemoteRepo>(() => EmployeeRemoteDs());
    _getIt.registerFactory<EmployeeCubit>(() => EmployeeCubit(repo: _getIt()));

    // delivery
    _getIt.registerFactory<DeliveryRepo>(() => DeliveryRemoteDs());
    _getIt.registerFactory<DeliveryCubit>(() => DeliveryCubit(repo: _getIt()));
  }

  static T get<T extends Object>() {
    return _getIt.get<T>();
  }
}
