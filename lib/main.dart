import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/themes.dart';
import 'package:gas/core/injections/container.dart';
import 'package:gas/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/core/config/api/firebase_options.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:gas/features/employee/presentation/cubit/employee_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Injections.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => Injections.get<AuthCubit>()),
        BlocProvider<HomeCubit>(create: (_) => Injections.get<HomeCubit>()),
        BlocProvider<BusinessCubit>(
            create: (_) => Injections.get<BusinessCubit>()),
        BlocProvider<EmployeeCubit>(
            create: (_) => Injections.get<EmployeeCubit>()),
        BlocProvider<DeliveryCubit>(
            create: (_) => Injections.get<DeliveryCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'GAS',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: ThemeMode.light,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
