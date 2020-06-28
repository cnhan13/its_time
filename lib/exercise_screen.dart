import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'exercise.dart';
import 'main.dart';

class ExerciseScreen extends StatelessWidget {
  ExerciseScreen({Key key, this.title, this.exerciseList}) : super(key: key);

  final String title;
  final List<Exercise> exerciseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).primaryTextTheme.headline6),
      ),
      body: ExerciseBody(exerciseList: exerciseList),
    );
  }
}

class ExerciseBody extends StatefulWidget {
  ExerciseBody({Key key, this.exerciseList}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final List<Exercise> exerciseList;

  @override
  _ExerciseBodyState createState() => _ExerciseBodyState();
}

class _ExerciseBodyState extends State<ExerciseBody> {
  Stopwatch stopwatch;
  Timer timer;
  FlutterTts tts;
  bool started;

  @override
  void initState() {
    super.initState();
    tts = FlutterTts();
    configureTts();
    resetExerciseList();
    stopwatch = Stopwatch();
    timer = Timer.periodic(Duration(milliseconds: 30), timerCallback);
    stopwatch.start();
  }

  void configureTts() {
    // All of these are async, but it's ok
    tts.setLanguage('en-US');
    tts.setVolume(1.0);
    tts.setPitch(1.0);
  }

  void timerCallback(Timer t) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  void startStopwatch() {
    setState(() {
      if (!stopwatch.isRunning) {
        stopwatch.start();
      }
    });
  }

  void stopStopwatch() {
    setState(() {
      if (stopwatch.isRunning) {
        stopwatch.stop();
      }
    });
  }

  void resetStopwatch() {
    setState(() {
      if (!stopwatch.isRunning) {
        stopwatch.reset();
        resetExerciseList();
      }
    });
  }

  void resetExerciseList() {
    widget.exerciseList.forEach((exercise) {
      exercise.reset();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget buildCurrentExerciseWidget(int curIndex, double sec) {
    Exercise exercise = widget.exerciseList[curIndex];
    double timeLeft = exercise.seconds - sec;
    double value = timeLeft.toDouble() / exercise.seconds;
    final themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        splashColor: Colors.indigo,
        child: SizedBox.expand(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${curIndex + 1}/${widget.exerciseList.length}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: themeData.primaryTextTheme.headline5.fontWeight,
                    fontSize: themeData.primaryTextTheme.headline5.fontSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${exercise.name}',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight:
                          themeData.primaryTextTheme.headline6.fontWeight,
                      fontSize: themeData.primaryTextTheme.headline6.fontSize,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 100),
                  child: CircularProgressIndicator(
                    strokeWidth: 100,
                    value: value,
                  ),
                ),
                Text(
                  '${timeLeft.ceil()}s',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: themeData.primaryTextTheme.headline3.fontWeight,
                    fontSize: themeData.primaryTextTheme.headline3.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          print('tap');
          stopwatch.isRunning ? stopStopwatch() : startStopwatch();
        },
      ),
    );
  }

  Widget buildCongratsWidget() {
    final themeData = Theme.of(context);
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            'Congratulations!',
            style: TextStyle(
              color: themeData.primaryColor,
                fontWeight: themeData.primaryTextTheme.headline5.fontWeight,
              fontSize: themeData.primaryTextTheme.headline5.fontSize,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNextExerciseWidget(int curIndex) {
    if (0 <= curIndex && curIndex < widget.exerciseList.length - 1) {
      Exercise nextX = widget.exerciseList[curIndex + 1];
      return ListTile(
        title: Text('Next: ${nextX.name}'),
        trailing: Text(
          '${nextX.seconds}s',
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      );
    } else {
      return ListTile(
        title: Text('The end.'),
      );
    }
  }

  ListTile buildTimerRow(
      {TimerState timerState, String name, int curSec, int seconds}) {
    Widget trailing;
    if (timerState == TimerState.waiting) {
      trailing = Text(
        '${seconds}s',
        style: Theme.of(context).textTheme.headline5,
      );
    } else if (timerState == TimerState.started) {
      trailing = Text(
        '${seconds - curSec}s',
        style: Theme.of(context).textTheme.headline4,
      );
    } else {
      trailing = Icon(
        Icons.check_circle_outline,
        color: Theme.of(context).primaryColor,
      );
    }
    return ListTile(
      title: Text(name),
      trailing: trailing,
    );
  }

  @override
  Widget build(BuildContext context) {
    Exercise curX;
    int curIndex = 0;

    double sec = stopwatch.elapsedMilliseconds / 1000;
    widget.exerciseList.forEach((exercise) {
      if (curX == null) {
        if (sec >= exercise.seconds) {
          sec -= exercise.seconds;
          curIndex++;
        } else if (sec >= 0) {
          curX = exercise;
        }
      }
    });
    var widgets = <Widget>[];
    if (curIndex < widget.exerciseList.length) {
      if (curX.speakName) {
        curX.speakName = false;
        tts.speak(curX.name);
      } else if (sec <= curX.seconds) {
        int timeLeft = curX.seconds - sec.floor();
        if (curX.speakSec.contains(timeLeft)) {
          curX.speakSec.remove(timeLeft);
          tts.speak(timeLeft.toString());
        }
      }
      widgets.add(buildCurrentExerciseWidget(curIndex, sec));
      widgets.add(buildNextExerciseWidget(curIndex));
    } else {
      if (stopwatch.isRunning) {
        stopwatch.stop();
        resetStopwatch();
      }
      widgets.add(buildCongratsWidget());
      String congrats = 'Congratulations!';
      tts.speak(congrats);
      // bye
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }
}
