import 'package:flutter/material.dart';
import 'package:tarsheed/home_page.dart';
import 'package:tarsheed/src/core/utils/color_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const Tarsheed());
}

class Tarsheed extends StatelessWidget {
  const Tarsheed({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.primary),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
