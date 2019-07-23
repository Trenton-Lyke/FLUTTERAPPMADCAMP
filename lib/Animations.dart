import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/CreateAccount.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';

class FadeIn extends StatefulWidget {
  @override
  final Widget child;
  final int duration;


  FadeIn({@required this.child, @required this.duration});
  createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  double begin = 0.0;
  double end = 1.0;
  @override
  void initState() {

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _animation = Tween(
      begin: begin,
      end: end,
    ).animate(_controller);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _controller.forward();

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

Future sleep5() {
  return new Future.delayed(const Duration(seconds: 5), () => "5");
}