import 'package:flutter/material.dart';

import 'exercise.dart';
import 'exercise_screen.dart';

enum TimerState { waiting, started, ended }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ExerciseListScreen(
          title: 'Exercise List', exerciseList: getExercises()),
    );
  }
}

class ExerciseListScreen extends StatelessWidget {
  ExerciseListScreen({Key key, this.title, this.exerciseList})
      : super(key: key);

  final String title;
  final List<Exercise> exerciseList;

  void _startExercise(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ExerciseScreen(title: 'Exercise', exerciseList: exerciseList)));
  }

  ListTile buildTimerRow({
    BuildContext context,
    TimerState timerState,
    String name,
    int curSec,
    int seconds,
  }) {
    Widget trailing;
    if (timerState == TimerState.waiting) {
      trailing = Text(
        '${seconds}s',
        style: Theme.of(context).textTheme.headline6,
      );
    } else if (timerState == TimerState.started) {
      trailing = Text(
        '${seconds - curSec}s',
        style: Theme.of(context).textTheme.headline6,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: exerciseList.length,
              itemBuilder: (BuildContext context, int index) {
                Exercise curX = exerciseList[index];
                return buildTimerRow(
                  context: context,
                  timerState: TimerState.waiting,
                  name: curX.name,
                  seconds: curX.seconds,
                );
              },
              separatorBuilder: (context, index) => Divider(),
            ),
          ),
          Card(
            child: GestureDetector(
              child: Container(
                height: 58,
                color: Theme.of(context).accentColor,
                child: Center(
                  child: Text('START',
                      style: Theme.of(context).primaryTextTheme.headline6),
                ),
              ),
              onTap: () {
                _startExercise(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
