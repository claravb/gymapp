import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gymapp/models/exercise.dart';
import 'package:gymapp/models/workout.dart';

class WorkoutsCubit extends Cubit<List<Workout>> {
  WorkoutsCubit() : super([]);

  getWorkouts() async {
    final List<Workout> workouts = [];
    final workoutsJson =
        jsonDecode(await rootBundle.loadString('assets/workouts.json'));
    for (var el in (workoutsJson as Iterable)) {
      workouts.add(Workout.fromJson(el));
    }
    emit(
        workouts); //takes a state to send a state or th things that has changed
  }

  saveWorkout(Workout workout, int index) {
    Workout newWorkout =
        Workout(title: workout.title, exercises: workout.exercises);
    int exIndex = 0;
    int startTime = 0;
    for (var ex in workout.exercises) {
      newWorkout.exercises.add(Exercise(
          title: ex.title,
          prelude: ex.prelude,
          duration: ex.duration,
          index: ex.index,
          startTime: ex.startTime));
      exIndex++;
      startTime += ex.prelude! + ex.duration!;
    }

    state[index] = newWorkout;
    print('I have ${state.length} states...');
    emit([...state]);
  }
}
