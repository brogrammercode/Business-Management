import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/themes.dart';
import 'package:gas/core/injections/container.dart';
import 'package:gas/features/consumer/presentation/bloc/consumer_bloc.dart';
import 'package:gas/firebase_options.dart';

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
        BlocProvider<ConsumerBloc>(
            create: (_) => Injections.get<ConsumerBloc>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.42857142857144, 843.4285714285714),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'GAS',
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
