import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradprj/core/routing/routes.dart';
import 'package:gradprj/core/routing/routing.dart';

void main() {
  runApp(GraduationProject(
    routing: Routing(),
  ));
}

class GraduationProject extends StatelessWidget {
  final Routing routing;
  const GraduationProject({super.key, required this.routing});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.notePage,
        onGenerateRoute: routing.generateRoute,
      ),
    );
  }
}
