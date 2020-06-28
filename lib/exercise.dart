import 'dart:collection';

class Exercise {
  String name;
  int minute;
  int seconds;
  bool speakName;
  HashSet<int> speakSec;

  Exercise({this.name, this.minute, this.seconds}) {
    reset();
  }

  void reset() {
    this.speakName = true;
    this.speakSec = HashSet.from([1, 2, 3]);
  }
}

List<Exercise> getExercises() {
  int secPerExercise = 5;
  return <Exercise>[
    Exercise(
      name: 'Ready to go',
      seconds: 10,
    ),
    Exercise(
      name: 'Sit-ups',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Knee touch crunches',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Heel touches',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Bicycle Crunches',
      seconds: secPerExercise,
    ),
    Exercise(
      name: '(Not) Russian Twists',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Reach Through Crunches',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Toe tap leg lifts',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Flutter kicks',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Scissor kicks',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Leg lifts',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Leg up alternating toe crunch',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Crunch kicks',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Mountain climbers',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Plank',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Right side plank',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Left side plank',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Plank',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Plank twists',
      seconds: secPerExercise,
    ),
    Exercise(
      name: 'Spider climbers',
      seconds: secPerExercise,
    ),
  ];
}
