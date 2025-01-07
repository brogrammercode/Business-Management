import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas/features/auth/presentation/pages/auth_page.dart';
import 'package:gas/features/consumer/presentation/pages/consumer_detail_page.dart';
import 'package:gas/features/home/presentation/pages/home_page.dart';
import 'package:gas/features/consumer/presentation/pages/add_consumer_page.dart';
import 'package:gas/features/organisation/presentation/pages/add_org_page.dart';

class AppRoutes {
  static const String core = '/';
  static const String auth = '/auth';
  static const String home = '/home';

  // org
  static const String addOrg = '/addOrg';

  // consumer
  static const String addUser = '/addUser';
  static const String consumerDetail = '/consumerDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case core:
        if (FirebaseAuth.instance.currentUser != null) {
          return MaterialPageRoute(builder: (_) => const HomePage());
        } else {
        return MaterialPageRoute(builder: (_) => const AuthPage());
        }
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      // org
      case addOrg:
        return MaterialPageRoute(builder: (_) => const AddOrgPage());

      // consumer
      case addUser:
        return MaterialPageRoute(builder: (_) => const AddConsumerPage());
      case consumerDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ConsumerDetailPage(
            consumer: args?['consumer'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(),
        );
    }
  }

  static Future<void> navigateTo(
      BuildContext context, String routeName, Object? arguments) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<void> replaceWith(BuildContext context, String routeName) {
    return Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }
}
