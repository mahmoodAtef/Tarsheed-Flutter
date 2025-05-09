import 'package:flutter/material.dart';

extension NavigationMethods on BuildContext {
  void pop() {
    Navigator.pop(this);
  }

  void push(Widget route) {
    Navigator.push(
      this,
      MaterialPageRoute(builder: (_) => route),
    );
  }

  void pushAndRemove(Widget route) {
    Navigator.pushAndRemoveUntil(
        this, MaterialPageRoute(builder: (_) => route), (route) => false);
  }

  void pushReplacement(Widget route) {
    Navigator.pushReplacement(
      this,
      MaterialPageRoute(builder: (_) => route),
    );
  }

  void pushWithTransition(
    Widget route, {
    Object? arguments,
  }) {
    Navigator.push(
      this,
      SlidePageRoute(child: route),
    );
  }
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget child;

  SlidePageRoute({required this.child})
      : super(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}
