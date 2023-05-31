import 'dart:math';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sehat_o_meter/widgets/age_weight_widget.dart';
import 'package:sehat_o_meter/widgets/gender_widget.dart';
import 'package:sehat_o_meter/widgets/height_widget.dart';
import 'package:sehat_o_meter/screens/score_screen.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ignore: unused_field
  int _gender = 0;
  int _height = 150;
  int _age = 30;
  int _weight = 50;
  bool _isFinished = false;
  double _bmiScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Sehat-o-Meter'),
      ),
      body: (SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Card(
            elevation: 12,
            shape: const RoundedRectangleBorder(),
            child: Column(
              children: [
                GenderWidget(
                  onChange: (genderVal) {
                    _gender = genderVal;
                  },
                ),
                HeightWidget(onChange: (heightVal) {
                  _height = heightVal;
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AgeWeightWidget(
                        onChange: (ageVal) {
                          _age = ageVal;
                        },
                        title: 'Age',
                        initValue: 30,
                        min: 0,
                        max: 100),
                    AgeWeightWidget(
                        onChange: (weightVal) {
                          _weight = weightVal;
                        },
                        title: 'Weight(Kg)',
                        initValue: 50,
                        min: 0,
                        max: 200),
                  ],
                ),
                // calculate button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 60,
                  ),
                  child: SwipeableButtonView(
                      isFinished: _isFinished,
                      onFinish: () async {
                        await Navigator.push(
                            context,
                            PageTransition(
                                child: ScoreScreen(
                                  bmiScore: _bmiScore,
                                  age: _age,
                                ),
                                type: PageTransitionType.fade));

                        setState(() {
                          _isFinished = false;
                        });
                      },
                      onWaitingProcess: () {
                        calculateBmi();

                        Future.delayed(Duration(seconds: 1), () {
                          setState(() {
                            _isFinished = true;
                          });
                        });
                      },
                      activeColor: Colors.blue,
                      buttonWidget: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                      buttonText: 'Calculate'),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  void calculateBmi() {
    _bmiScore = _weight / pow(_height / 100, 2);
  }
}
