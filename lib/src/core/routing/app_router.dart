import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/routing/routes.dart';

import '../../modules/settings/ui/screens/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    // print(settings.toString());
    switch (settings.name) {
      case Routes.initialRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      default:
        return MaterialPageRoute(builder: (_) => EmptyScreen());
    }
  }
}

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phonelink_erase_rounded),
            Text(
              'No route defined',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    ));
  }
}
