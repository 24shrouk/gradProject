import 'package:flutter/material.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/views/get_started.dart';
import 'package:gradprj/views/home/ui/screens/home.dart';
import 'package:gradprj/views/login/ui/screen/login.dart';
import 'package:gradprj/views/sing_up/ui/screen/sing_up.dart';

class Routing {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.getStarted:
        return MaterialPageRoute(
            builder: (context) => const GetStartedScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (context) => const Login());
      case Routes.singUp:
        return MaterialPageRoute(builder: (context) => const SignUp());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());

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
