import 'package:flutter/material.dart';
import 'dart:math';

class DiceRollScreen extends StatefulWidget {
  final Widget nextScreen;
  const DiceRollScreen({super.key, required this.nextScreen});

  @override
  DiceRollScreenState createState() => DiceRollScreenState();
}

class DiceRollScreenState extends State<DiceRollScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _diceNumber = 1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );

    _controller.addListener(() {
      setState(() {});
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => widget.nextScreen),
        );
      }
    });
  }

  void _rollDice() {
    setState(() {
      _diceNumber = Random().nextInt(6) + 1;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: GestureDetector(
          onTap: _rollDice,
          child: Transform.rotate(
            angle: _animation.value * 2 * pi,
            child: Image.asset(
              'assets/images/dice_$_diceNumber.png',
              height: 200,
              width: 200,
            ),
          ),
        ),
      ),
    );
  }
}
