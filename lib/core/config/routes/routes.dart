import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gas/features/auth/presentation/pages/auth_page.dart';
import 'package:gas/features/business/presentation/pages/add_business_page.dart';
import 'package:gas/features/business/presentation/pages/employee_track_page.dart';
import 'package:gas/features/business/presentation/pages/track_page.dart';
import 'package:gas/features/delivery/presentation/pages/add_consumer_page.dart';
import 'package:gas/features/delivery/presentation/pages/all_consumer_page.dart';
import 'package:gas/features/delivery/presentation/pages/consumer_detail_page.dart';
import 'package:gas/features/delivery/presentation/pages/delivery_page.dart';
import 'package:gas/features/delivery/presentation/pages/finish_delivery_page.dart';
import 'package:gas/features/home/presentation/pages/home_page.dart';

class AppRoutes {
  static const String core = '/';
  static const String auth = '/auth';
  static const String home = '/home';

  // business
  static const String addBusiness = '/addBusiness';

  // consumer
  static const String addUser = '/addUser';
  // static const String consumerDetail = '/consumerDetail';

  // delivery
  static const String delivery = '/deliveryMain';
  static const String addConsumer = '/addConsumer';
  static const String allConsumer = '/allConsumer';
  static const String consumerDetail = '/consumerDetail';
  static const String finishDelivery = '/finishDelivery';

  // employee
  static const String employeeTrack = '/employeeTrack';
  static const String trackPage = '/trackPage';

  // route
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

      // business
      case addBusiness:
        return MaterialPageRoute(builder: (_) => const AddBusinessPage());

      // delivery
      case delivery:
        return MaterialPageRoute(builder: (_) => const DeliveryPage());
      case addConsumer:
        return MaterialPageRoute(builder: (_) => const AddConsumerPage());
      case allConsumer:
        return MaterialPageRoute(builder: (_) => const AllConsumerPage());
      case consumerDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
            builder: (_) => ConsumerDetailPage(consumer: args?['consumer']));
      case finishDelivery:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FinishDeliveryPage(delivery: args?["delivery"]),
        );

      // employee
      case employeeTrack:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EmployeeTrackPage(employeeID: args?['employeeID']),
        );
      case trackPage:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TrackPage(employeeID: args?['employeeID']),
        );

      // default
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
