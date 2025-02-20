import 'package:flutter/material.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/views/login/ui/screen/login.dart';

class Routing {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const Login());
      default:
        return MaterialPageRoute(builder: (context) => const NoRouteScreen());
    }
  }
}

class BlocProvider {}

class NoRouteScreen extends StatelessWidget {
  const NoRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Route Founde"),
      ),
    );
  }
}
